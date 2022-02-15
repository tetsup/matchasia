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

  def bulk_search
    @query_params = LessonRangeQuery.new
    render :bulk_new
  end

  def bulk_new
    @query_params = LessonRangeQuery.new(bulk_query_params)
    return if @query_params.valid?

    render :bulk_new, alert: @query_params.errors.full_messages.join(', ')
  end

  def bulk_create
    create_params = bulk_create_params
    ActiveRecord::Base.transaction do
      create_count = 0
      create_params[:start_time].each do |start_time, flag|
        next if flag != '1'

        lesson = current_teacher.lessons.build(
          language_id: create_params[:language_id],
          start_time: Time.strptime(start_time, '%Y-%m-%d %H')
        )
        if lesson.save
          create_count += 1
        else
          flash[:alert] = "#{lesson.start_time.to_s(:datetime_jp)}のレッスン登録に失敗しました(#{lesson.errors.full_messages})"
        end
      end
      redirect_to teachers_lessons_path, notice: "#{create_count}件のレッスンを一括登録しました"
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(Lesson::REGISTARABLE_ATTRIBUTES)
  end

  def bulk_query_params
    params.require(:lesson_range_query)
          .permit([:start_date, :end_date, :start_hour, :end_hour])
  end

  def bulk_create_params
    params.fetch(:lessons).permit(:language_id).tap do |whitelisted|
      whitelisted[:start_time] = params[:lessons][:start_time]
    end
  end
end
