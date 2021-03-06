class Teacher < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  validates :username,
    presence: true,
    length: { in: 3..20 },
    format: { with: /\A[a-zA-Z][a-zA-Z0-9]+\z/ },
    uniqueness: true
  validates :about, length: { maximum: 200 }
  has_many :lessons, dependent: :destroy
  has_many :reservations, through: :lessons
  has_many :feedbacks, through: :lessons
  has_many :reports, through: :lessons
  has_one_attached :photo
  belongs_to_active_hash :language

  def password_required?
    super if confirmed?
  end
end
