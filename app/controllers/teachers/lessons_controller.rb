class Teachers::LessonsController < ApplicationController
  before_action :authenticate_teacher!

  def index
    @lessons = current_teacher
               .lessons
               .eager_load(:reservation)
               .eager_load(:reserve_student)
               .eager_load(:feedback)
               .eager_load(:report)
               .sorted
  end

  def new
    @lesson = current_teacher.lessons.new
  end

  def create
    lesson = current_teacher.lessons.build(lesson_params)
    if lesson.save
      redirect_to teachers_lessons_path, method: :get, notice: '正常に作成できました'
    else
      redirect_to new_teachers_lesson_path, alert: lesson.errors.full_messages.join(', ')
    end
  end

  def bulk_new
    query_params = bulk_query_params
    @start_date = Date.parse(query_params[:start_date])
    @end_date = Date.parse(query_params[:end_date])
    @start_hour = query_params[:start_hour].to_i
    @end_hour = query_params[:end_hour].to_i
    @languages = Language.all
  end

  def bulk_create
    create_params = bulk_create_params
    ActiveRecord::Base.transaction do
      create_params[:start_time].each do |start_time, flag|
        next if flag != '1'

        next if current_teacher.lessons.create(
          language_id: create_params[:language_id],
          start_time: Time.strptime(start_time, '%Y-%m-%d %H')
        )

        render :bulk_new
      end
      redirect_to teachers_lessons_path, notice: 'レッスンを一括登録しました'
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(Lesson::REGISTARABLE_ATTRIBUTES)
  end

  def bulk_query_params
    params.fetch(:query, {start_date: Date.today.to_s(:date_query), end_date: 1.weeks.from_now.to_s(:date_query), start_hour: '7', end_hour: '22'})
          .permit([:start_date, :end_date, :start_hour, :end_hour])
  end

  def bulk_create_params
    params.fetch(:lessons).permit(:language_id).tap do |whitelisted|
      whitelisted[:start_time] = params[:lessons][:start_time]
    end
  end
end
