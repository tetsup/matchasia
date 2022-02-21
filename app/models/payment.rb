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
  enum payment_phase: { requested: 0, extended: 1, canceled: -1 }

  def stripe_session(success_url, cancel_url)
    session = Stripe::Checkout::Session.create({
      customer: student.stripe_customer_id,
      line_items: [{ price: price[:stripe_price_id], quantity: 1 }],
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url
    })
    self.payment_intent = session.payment_intent
    session
  end

  def self.from_event(webhook_event)
    payment = find_by(payment_intent: webhook_event.data.object.payment_intent)
    payment.student.stripe_customer_id != webhook_event.data.object.customer && (raise ActionController::BadRequest)
    payment
  rescue ActionController::BadRequest
    logger.error "checkout.session.completedイベントのデータ不整合(payment_intent: #{webhook_event.payment_intent})"
    nil
  end

  def self.extend_tickets(webhook_event)
    payment = from_event(webhook_event)
    return if payment.nil?

    ActiveRecord::Base.transaction do
      payment.tickets_before = payment.student.tickets
      payment.student.tickets += payment.price.tickets
      payment.tickets_after = payment.student.tickets
      payment.payment_phase = :extended
      payment.student.save!
      payment.save!
    rescue StandardError # 何が起きたとしてもインシデントとして報告
      logger.error "チケット購入時の追加処理でエラー(payment_intent: #{webhook_event.payment_intent})"
    end
  end
end
