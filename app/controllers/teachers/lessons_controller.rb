class Teachers::LessonsController < ApplicationController
  before_action :authenticate_teacher!

  def index
    @lessons = current_teacher.lessons.eager_load(:reserve_student).from_now.sorted
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

  private

  def lesson_params
    params.require(:lesson).permit(Lesson::REGISTARABLE_ATTRIBUTES)
  end
end
