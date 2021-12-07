class Students::ReservationsController < ApplicationController
  before_action :authenticate_student!

  def index
    @reservations = current_student.reservations.load_lesson_with_filter.includes(lesson: :teacher)
  end
end
