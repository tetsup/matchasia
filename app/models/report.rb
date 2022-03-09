class Report < ApplicationRecord
  belongs_to :lesson

  validates :content, presence: true, length: { maximum: 200 }
  validate :lesson_is_finished
  validate :lesson_is_not_reserved

  def lesson_is_finished
    errors.add(:lesson, '終了していないレッスンにはレポートを入力できません') unless lesson.finished?
  end

  def lesson_is_not_reserved
    errors.add(:lesson, '予約されていないレッスンにはレポートを入力できません') if lesson.reservation.nil?
  end
end
