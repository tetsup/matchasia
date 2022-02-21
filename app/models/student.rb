class Student < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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
  has_many :reservations
  has_many :payments

  def create_stripe_customer_id
    return if stripe_customer_id.present?

    customer = Stripe::Customer.create({ email: email })
    self.stripe_customer_id = customer.id
    save!
  end
end
