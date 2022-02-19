class Students::Lessons::ReservationsController < ApplicationController
  before_action :authenticate_student!

  def create
    current_student.tickets -= 1
    if current_student.valid?
      reservation = current_student.reservations.build({ lesson_id: params[:lesson_id] })
      reservation.assign_zoom_url!
      ActiveRecord::Base.transaction do
        current_student.save!
        reservation.save!
      end
      TeacherMailer.reserve(reservation).deliver_later
      StudentMailer.reserve(reservation).deliver_later
      redirect_to students_lessons_path, method: :get, notice: '予約が完了しました'
    else
      redirect_to students_lessons_path, method: :get, alert: (current_student.errors.full_messages).join(', ')
    end
  rescue
    redirect_to students_lessons_path, method: :get, alert: (current_student.errors.full_messages + reservation.errors.full_messages).join(', ')
  end
end
