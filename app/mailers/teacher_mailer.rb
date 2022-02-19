class TeacherMailer < ApplicationMailer
  def reserve(reservation)
    @reservation = reservation
    mail(
      to: @reservation.lesson.teacher.email,
      subject: "レッスンが予約されました(#{@reservation.lesson.start_time.to_s(:datetime_jp)})"
    )
  end
end
