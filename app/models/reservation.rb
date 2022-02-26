class Reservation < ApplicationRecord
  belongs_to :student
  belongs_to :lesson

  with_options presence: true do
    validates :lesson, uniqueness: true
    validates :tickets_before, :tickets_after
    validates :start_url, :join_url, {
      format: { with: %r{https?://.+} },
      uniqueness: true,
      unless: :spend_ticket
    }
  end
  validate :lesson_start_time_expect_to_be_after_now

  def lesson_start_time_expect_to_be_after_now
    errors.add(:lesson, '開始時刻を過ぎているレッスンは予約できません') if lesson.started?
  end

  scope :load_lesson_not_started, lambda {
    eager_load(:lesson)
      .where('lessons.start_time > ?', Time.now.ago(Lesson::MEETING_DURATION_MINUTES.minute))
  }
  scope :sorted, -> { order('lessons.start_time asc') }

  def reserve
    return false unless lesson.valid?

    return false unless spend_ticket

    zoom_meeting
    return false unless valid?

    ActiveRecord::Base.transaction do
      student.save!
      save!
    rescue ActiveRecord::RecordInvalid
      return false
    end
    reserved_mail
    true
  end

  def spend_ticket
    self.tickets_before = student.tickets
    student.tickets -= 1
    self.tickets_after = student.tickets
    # student.valid?
    # ここでチケットだけをバリデーションしてzoom会議作成を抑制したい
    # (実際にはミーティング開く人がいないので実害はないが、講師のzoom管理画面からは開始出来てしまう)
  end

  def zoom_meeting
    meeting = Zoom.new.meeting_create(
      user_id: lesson.teacher.zoom_user_id,
      start_time: lesson.start_time.in_time_zone('UTC'),
      duration: Lesson::MEETING_DURATION_MINUTES
    )
    self.start_url = meeting['start_url']
    self.join_url = meeting['join_url']
  end

  def reserved_mail
    TeacherMailer.reserve(self).deliver_later
    StudentMailer.reserve(self).deliver_later
  end
end
