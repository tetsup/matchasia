class AdminMailer < ApplicationMailer
  def zoom_id_not_found(teacher)
    @teacher = teacher
    mail(
      to: Admin.pluck(:email),
      subject: 'zoomアカウントを連携させていないため、ミーティング作成に失敗しました'
    )
  end

  def failed_to_add_zoom_user(teacher)
    @teacher = teacher
    mail(
      to: Admin.pluck(:email),
      subject: 'zoomアカウントの追加に失敗しました'
    )
  end

  def failed_to_payment_verification(payment)
    @payment = payment
    mail(
      to: Admin.pluck(:email),
      subject: '決済の完了処理に失敗しました'
    )
  end
end
