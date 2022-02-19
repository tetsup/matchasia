class Feedback < ApplicationRecord
  belongs_to :lesson

  validates :content, presence: true, length: { maximum: 200 }
  validate :lesson_is_finished
  validate :lesson_is_not_reserved

  def lesson_is_finished
    errors.add(:lesson, '終了していないレッスンにはフィードバックできません') unless lesson.finished?
  end

  def lesson_is_not_reserved
    errors.add(:lesson, '予約されていないレッスンにはフィードバックできません') if lesson.reservation.nil?
  end
end
