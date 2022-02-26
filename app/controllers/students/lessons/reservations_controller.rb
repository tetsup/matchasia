class Students::Lessons::ReservationsController < ApplicationController
  before_action :authenticate_student!

  def create
    reservation = current_student.reservations.build(lesson_id: params[:lesson_id])
    if reservation.reserve
      redirect_to students_lessons_path, method: :get, notice: '予約が完了しました'
    else
      redirect_to students_lessons_path,
                  method: :get,
                  alert: (current_student.errors.full_messages + reservation.errors.full_messages + reservation.lesson.errors.full_messages).join(', ')
    end
  rescue Zoom::Error => e
    redirect_to students_lessons_path, method: :get, danger: "Zoom予約のエラーにより、予約が失敗しました。管理者にお問い合わせください: #{e.message}"
  end
end
