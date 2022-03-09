class Students::PaymentsController < ApplicationController
  before_action :authenticate_student!

  def new
    @payment = current_student.payments.build
  end

  def create
    payment = current_student.payments.build({ price_id: price_params[:price] })
    session = payment.stripe_session(
      success_students_payments_url,
      cancel_students_payments_url
    )
    if payment.save
      redirect_to session.url, status: :see_other
    else
      redirect_to new_students_payment_path, alert: payment.errors.full_messages.join(', ')
    end
  end

  def success
    flash[:notice] = 'チケットを購入しました 決済情報が届き次第、チケットが追加されます'
    redirect_to new_students_payment_path
  end

  def cancel
    flash[:alert] = 'チケットの購入をキャンセルしました'
    redirect_to new_students_payment_path
  end

  private

  def price_params
    params.require(:payment).permit(:price)
  end

  def find_payment
    current_student.payments.find_by(stripe_payment_id: params[:payment_id])
  end
end
