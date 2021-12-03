class Students::Lessons::ReservationsController < ApplicationController
  before_action :authenticate_student!

  def create
    reservation = current_student.reservations.build({ lesson_id: params[:lesson_id] })
    reservation.assign_zoom_url!
    if reservation.save
      TeacherMailer.reserve(reservation).deliver_later
      StudentMailer.reserve(reservation).deliver_later
      redirect_to students_lessons_path, method: :get, notice: '予約が完了しました'
    else
      redirect_to students_lessons_path, method: :get, alert: reservation.errors.full_messages.join(', ')
    end
  end
end
