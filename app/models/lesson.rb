class Lesson < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  has_one :reservation, dependent: :destroy
  has_one :reserve_student, through: :reservation, source: :student
  has_one :feedback
  has_one :report
  belongs_to :teacher
  belongs_to_active_hash :language

  MEETING_DURATION_MINUTES = 50
  MIN_HOUR = 7
  MAX_HOUR = 22
  REGISTARABLE_ATTRIBUTES = %i(
    teacher_id
    start_time(1i) start_time(2i) start_time(3i) start_time(4i)
    language_id
  )

  validates :start_time, uniqueness: { scope: :teacher_id }
  validates :language, presence: true
  validate :start_time_expect_to_be_after_now
  validate :start_hour_in_range

  def start_time_expect_to_be_after_now
    errors.add(:start_time, 'は現在より後の時刻を指定してください') if self.start_time < Time.now
  end

  def start_hour_in_range
    errors.add(:start_time, "は#{MIN_HOUR}時から#{MAX_HOUR}時の間で指定してください") unless start_time.hour.between?(MIN_HOUR, MAX_HOUR)
  end

  scope :from_now, -> { where(start_time: Time.now..) }
  scope :sorted, -> { order(start_time: :asc) }
  scope :filter_by_language, ->(language_id) { where(language_id: language_id) if language_id.present? }
  scope :filter_by_date_range, ->(start_date, end_date) {
    where(start_time: start_date.beginning_of_day..end_date.end_of_day)
  }
  scope :fetch_start_time_local, -> { select("(lessons.start_time + interval '9 hour') as start_time_local") }
  scope :fetch_group_columns, -> { select([:teacher_id, :language_id]) }

  def end_time
    start_time + MEETING_DURATION_MINUTES.minute
  end

  def started?
    start_time < Time.now
  end

  def finished?
    end_time <= Time.now
  end

  def self.group_by_local_date_and_time(lesson_sub_query)
    from(lesson_sub_query.fetch_start_time_local, :lessons_as_local)
      .group('DATE(start_time_local)')
      .group("DATE_PART('hour', start_time_local)::integer")
  end

  def self.group_by_local_month(lesson_sub_query)
    from(lesson_sub_query.fetch_start_time_local.fetch_group_columns, :lessons_as_local)
      .group("DATE_TRUNC('month', start_time_local)")
  end

  def self.group_by_local_date(lesson_sub_query)
    from(lesson_sub_query.fetch_start_time_local.fetch_group_columns, :lessons_as_local)
      .group('DATE(start_time_local)')
  end

  def self.count_by_date_and_time(start_date, end_date)
    group_by_local_date_and_time(
      filter_by_date_range(start_date, end_date)
    ).count
  end

  def self.reserved_count_by_date_and_time(start_date, end_date)
    group_by_local_date_and_time(
      filter_by_date_range(start_date, end_date)
        .joins(:reservation)
    ).count
  end

  def self.count_by_month_and_teacher
    group_by_local_month(Lesson).group(:teacher_id).count
  end

  def self.reserved_count_by_month_and_teacher
    group_by_local_month(Lesson.joins(:reservation)).group(:teacher_id).count
  end

  def self.count_by_date_and_teacher(start_date, end_date)
    group_by_local_date(
      filter_by_date_range(start_date, end_date)
    ).group(:teacher_id).count
  end

  def self.reserved_count_by_date_and_teacher(start_date, end_date)
    group_by_local_date(
      filter_by_date_range(start_date, end_date).joins(:reservation)
    ).group(:teacher_id).count
  end

  def self.count_by_month_and_language
    group_by_local_month(Lesson).group(:language_id).count
  end

  def self.reserved_count_by_month_and_language
    group_by_local_month(Lesson.joins(:reservation)).group(:language_id).count
  end

  def self.count_by_date_and_language(start_date, end_date)
    group_by_local_date(
      filter_by_date_range(start_date, end_date)
    ).group(:language_id).count
  end

  def self.reserved_count_by_date_and_language(start_date, end_date)
    group_by_local_date(
      filter_by_date_range(start_date, end_date).joins(:reservation)
    ).group(:language_id).count
  end

  def self.date_range
    [minimum(:start_time), maximum(:start_time)]
  end
end

class LessonRangeQuery
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :start_date, :date, default: Date.today
  attribute :end_date, :date, default: 7.day.from_now
  attribute :start_hour, :integer, default: 7
  attribute :end_hour, :integer, default: 22

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :too_mach_time_difference
  def too_mach_time_difference
    errors.add(:end_date, '期間は1か月以内である必要があります') if end_date > 1.month.after(start_date)
  end
  validates :start_hour, presence: true, numericality: {
    greater_than_or_equal_to: Lesson::MIN_HOUR,
    less_than_or_equal_to: Lesson::MAX_HOUR
  }
  validates :end_hour, presence: true, numericality: {
    greater_than_or_equal_to: :start_hour,
    less_than_or_equal_to: Lesson::MAX_HOUR
  }
end
