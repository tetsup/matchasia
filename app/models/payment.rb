class Payment < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :student
  belongs_to_active_hash :price

  with_options presence: true do
    validates :student
    validates :payment_intent, uniqueness: true
    validates :price
    validates :payment_phase
  end
  validates :tickets_before, numericality: { greater_than: 0, allow_nil: true }
  validates :tickets_after, numericality: { greater_than: :tickets_before, allow_nil: true }
  enum payment_phase: { requested: 0, extended: 1 }

  TAX_ID = 'txr_1Jy6D3CGxjuXgfl8RakSQn6O'.freeze

  def stripe_session(success_url, cancel_url)
    session = Stripe::Checkout::Session.create({
      customer: student.stripe_customer_id,
      line_items: [{
        price: price[:stripe_price_id],
        quantity: 1,
        tax_rates: [TAX_ID]
      }],
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url
    })
    self.payment_intent = session.payment_intent
    session
  end

  def self.from_event(webhook_event)
    payment = find_by(payment_intent: webhook_event.data.object.id)
    payment.nil? && (raise ActionController::BadRequest)
    payment.student.stripe_customer_id != webhook_event.data.object.customer && (raise ActionController::BadRequest)
    payment
  rescue StandardError => e
    logger.fatal 'payment_intent.succeededイベントのデータ不整合'
    logger.fatal webhook_event
    logger.fatal e.backtrace.join('\n')
    AdminMailer.failed_to_payment_verification(webhook_event)
    raise
  end

  def extend_tickets!
    ActiveRecord::Base.transaction do
      return unless requested?

      self.tickets_before = student.tickets
      student.tickets += price.tickets
      self.tickets_after = student.tickets
      extended!
      student.save!
      save!
    rescue StandardError => e
      logger.fatal "チケット購入時の追加処理でエラー(payment_intent: #{payment_intent})"
      logger.fatal e.backtrace.join('\n')
      AdminMailer.failed_to_payment_verification(self)
      raise
    end
  end
end
