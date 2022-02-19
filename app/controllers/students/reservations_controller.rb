class Students::ReservationsController < ApplicationController
  before_action :authenticate_student!

  def index
    @reservations = current_student.reservations.load_lesson_not_started.includes(lesson: :teacher)
  end
end
