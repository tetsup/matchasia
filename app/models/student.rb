class Student < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username,
    presence: true,
    length: { in: 3..20 },
    format: { with: /\A[a-zA-Z]+\z/ },
    uniqueness: true
  validates :tickets,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }
end
