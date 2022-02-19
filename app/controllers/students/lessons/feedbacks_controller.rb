class Students::Lessons::FeedbacksController < ApplicationController
  before_action :authenticate_student!

  def show
    @lesson = current_student.reservations.find_by(lesson_id: params[:lesson_id]).lesson
  end
end
