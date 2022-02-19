class Students::ReservationsController < ApplicationController
  before_action :authenticate_student!

  def index
    @reservations = current_student.reservations.includes(lesson: :teacher).includes(lesson: :feedback).sorted
  end
end
