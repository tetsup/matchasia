class Reservation < ApplicationRecord
  validates :lesson_id, uniqueness: true
  validates :url, {
    presence: true,
    format: { with: %r{https?://.+} },
    uniqueness: true
  }
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
