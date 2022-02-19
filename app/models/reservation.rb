class Reservation < ApplicationRecord
  belongs_to :student
  belongs_to :lesson

  validates :lesson, uniqueness: true
  validates :start_url, :join_url, {
    presence: true,
    format: { with: %r{https?://.+} },
    uniqueness: true
  }
  validate :lesson_start_time_expect_to_be_after_now

  def lesson_start_time_expect_to_be_after_now
    errors.add(:lesson, '開始時刻を過ぎているレッスンは予約できません') if lesson.started?
  end

  scope :load_lesson_not_started, lambda {
    eager_load(:lesson)
      .where('lessons.start_time > ?', Time.now.ago(Lesson::MEETING_DURATION_MINUTES.minute))
  }
  scope :sorted, -> { order('lessons.start_time asc') }

  def create
  end

  def assign_zoom_url!
    if lesson.valid? && !Reservation.where(lesson: lesson).exists? # zoomの処理には入れるべきではない → 予約処理の判定
      zoom_client = Zoom.new
      user_id = zoom_client.user_list['users'].first['id'] # 何が取り出されるのか
      meeting = zoom_client.meeting_create(
        user_id: user_id,
        start_time: lesson.start_time.in_time_zone('UTC'),
        duration: Lesson::MEETING_DURATION_MINUTES
      )
      self.start_url = meeting['start_url']
      self.join_url = meeting['join_url']
    end
    nil
  end
end
