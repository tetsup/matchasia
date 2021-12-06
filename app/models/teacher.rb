class Teacher < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable
  validates :username,
    presence: true,
    length: { in: 3..20 },
    format: { with: /\A[a-zA-Z]+\z/ },
    uniqueness: true
  validates :about, length: { maximum: 200 }
  has_many :lessons, dependent: :destroy
  has_one_attached :photo
end
