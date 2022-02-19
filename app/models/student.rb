class Student < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reservations

  validates :username,
    presence: true,
    length: { in: 3..20 },
    format: { with: /\A[a-zA-Z][a-zA-Z0-9]+\z/ },
    uniqueness: true
  validates :tickets,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }

  INSTANT_TICKET_PRODUCTS = {
    1 => { amount: 2200, currency: 'jpy', description: 'チケット1枚' },
    3 => { amount: 5500, currency: 'jpy', description: 'チケット3枚' },
    5 => { amount: 8250, currency: 'jpy', description: 'チケット5枚' }
  }

  def buy_tickets!(ticket_qty, email, token)
    product = INSTANT_TICKET_PRODUCTS[ticket_qty] # 通っちゃう
    customer = Stripe::Customer.create({ email: email, source: token })
    Stripe::Charge.create(product.merge({ customer: customer.id }))
  rescue Stripe::CardError => e
  end
end
