class Feedback < ApplicationRecord
  validates :content, presence: true, length: { maximum: 200 }
  validate :lesson_is_finished

  def lesson_is_finished
    errors.add(:lesson, '終了していないレッスンにはフィードバックできません') unless lesson.finished?
  end

  belongs_to :lesson
end
