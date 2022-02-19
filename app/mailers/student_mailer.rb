class StudentMailer < ApplicationMailer
  def reserve(reservation)
    @reservation = reservation
    mail(
      to: @reservation.student.email,
      subject: "レッスンが予約されました(#{@reservation.lesson.start_time.to_s(:datetime_jp)})"
    )
  end

  def feedback(feedback)
    @feedback = feedback
    mail(
      to: @feedback.lesson.reservation.student.email,
      subject: "講師からレッスンのフィードバックがあります(#{@feedback.lesson.start_time.to_s(:datetime_jp)})"
    )
  end
end
