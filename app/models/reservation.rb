class Reservation < ApplicationRecord
  validates :lesson_id, uniqueness: true
  validates :url, {
    presence: true,
    format: { with: %r{https?://.+} },
    uniqueness: true
  }
  validate :lesson_start_time_expect_to_be_after_now

  def lesson_start_time_expect_to_be_after_now
    errors.add(:lesson, '開始時刻を過ぎているレッスンは予約できません') if self.lesson.start_time < Time.now
  end

  belongs_to :student
  belongs_to :lesson

  def generate_zoom_url
    start_time = lesson.start_time
    zoom_client = Zoom.new
    user_id = zoom_client.user_list['users'].first['id']
    meeting = zoom_client.meeting_create(user_id: user_id, start_time: start_time.in_time_zone('UTC'), duration: 50)
    meeting['join_url']
  end
end
