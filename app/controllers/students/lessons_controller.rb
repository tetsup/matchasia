class Students::LessonsController < ApplicationController
  before_action :authenticate_student!

  def index
    @lessons = Lesson
               .eager_load(:reservation)
               .preload(:teacher)
               .filter_by_language(lesson_params[:language_id])
               .from_now
               .sorted
    @form_lesson = Lesson.new(lesson_params)
  end

  private

  def lesson_params
    params.fetch(:lesson, {}).permit(:language_id)
  end
end
