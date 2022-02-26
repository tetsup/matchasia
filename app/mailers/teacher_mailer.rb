class TeacherMailer < ApplicationMailer
  def reserve(reservation)
    @reservation = reservation
    mail(
      to: @reservation.lesson.teacher.email,
      subject: "レッスンが予約されました(#{@reservation.lesson.start_time.to_s(:datetime_jp)})"
    )
  end

  def zoom_id_not_found(teacher)
    @teacher = teacher
    mail(
      to: @teacher.email,
      subject: 'zoomアカウントを連携させてください'
    )
  end
end
