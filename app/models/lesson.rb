class Lesson < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  validates :start_time, uniqueness: { scope: :teacher_id }
  validates :language_id, presence: true
  has_one :reservation, dependent: :destroy
  has_one :reserve_student, through: :reservation, source: :student
  belongs_to :teacher
  belongs_to_active_hash :language

  REGISTARABLE_ATTRIBUTES = %i(
    teacher_id
    start_time(1i) start_time(2i) start_time(3i) start_time(4i)
    language_id
  )
end
