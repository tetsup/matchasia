class Lesson < ApplicationRecord
  MEETING_DURATION_MINUTES = 50
  extend ActiveHash::Associations::ActiveRecordExtensions
  validates :start_time, uniqueness: { scope: :teacher_id }
  validates :language, presence: true
  validate :start_time_expect_to_be_after_now

  def start_time_expect_to_be_after_now
    errors.add(:start_time, 'は現在より後の時刻を指定してください') if self.start_time < Time.now
  end

  has_one :reservation, dependent: :destroy
  has_one :reserve_student, through: :reservation, source: :student
  has_one :feedback
  belongs_to :teacher
  belongs_to_active_hash :language

  scope :from_now, -> { where(start_time: Time.now..) }
  scope :sorted, -> { order(start_time: :asc) }
  scope :filter_by_language, ->(language_id) { where(language_id: language_id) if language_id.present? }

  REGISTARABLE_ATTRIBUTES = %i(
    teacher_id
    start_time(1i) start_time(2i) start_time(3i) start_time(4i)
    language_id
  )

  def end_time
    start_time + MEETING_DURATION_MINUTES.minute
  end

  def started?
    start_time < Time.now
  end

  def finished?
    end_time <= Time.now
  end
end
