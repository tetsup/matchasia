class Admins::ReservationsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @start_date = Date.parse(query_params[:start_date]) rescue 1.week.ago(Date.today)
    @end_date = Date.parse(query_params[:end_date]) rescue Date.today
    @lessons_counts = Lesson.count_by_date_and_time(@start_date, @end_date)
    @reservations_counts = Lesson.reserved_count_by_date_and_time(@start_date, @end_date)
  end

  private

  def query_params
    params.fetch(:query, { start_date: Date.today, end_date: Date.today }).permit(:start_date, :end_date)
  end
end
