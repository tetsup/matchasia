class Admins::ReservationsController < ApplicationController
  before_action :authenticate_admin!
  before_action :query_dates

  def index
    @lessons_counts = Lesson.count_by_date_and_time(@start_date, @end_date)
    @reservations_counts = Lesson.reserved_count_by_date_and_time(@start_date, @end_date)
  end

  def by_teacher
    @teachers = Teacher.all
    case params[:span]
    when 'monthly'
      @lessons_counts = Lesson.count_by_month_and_teacher
      @reservations_counts = Lesson.reserved_count_by_month_and_teacher
      render 'by_teacher_and_month'
    when 'daily'
      @lessons_counts = Lesson.count_by_date_and_teacher(@start_date, @end_date)
      @reservations_counts = Lesson.reserved_count_by_date_and_teacher(@start_date, @end_date)
      render 'by_teacher_and_date'
    end
  end

  def by_language
    @languages = Language.all
    case params[:span]
    when 'monthly'
      @lessons_counts = Lesson.count_by_month_and_language
      @reservations_counts = Lesson.reserved_count_by_month_and_language
      render 'by_language_and_month'
    when 'daily'
      @lessons_counts = Lesson.count_by_date_and_language(@start_date, @end_date)
      @reservations_counts = Lesson.reserved_count_by_date_and_language(@start_date, @end_date)
      render 'by_language_and_date'
    end
  end

  private

  def query_params
    params.fetch(:query, { start_date: Date.today, end_date: Date.today }).permit(:start_date, :end_date)
  end

  def query_dates
    @start_date = Date.parse(query_params[:start_date]) rescue 1.week.ago(Date.today)
    @end_date = Date.parse(query_params[:end_date]) rescue Date.today
  end
end
