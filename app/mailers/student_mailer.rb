class StudentMailer < ApplicationMailer
  def reserve(reservation)
    @reservation = reservation
    mail(
      to: @reservation.student.email,
      subject: "レッスンが予約されました(#{@reservation.lesson.start_time.to_s(:datetime_jp)})"
    )
  end
end
