class Students::PaymentsController < ApplicationController
  before_action :authenticate_student!

  def new
    @payment = current_student.payments.new
  end

  def create
    current_student.create_stripe_customer_id
    payment = current_student.payments.new({ price_id: price_params[:price] })
    session = payment.stripe_session(
      "#{success_students_payments_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_students_payments_url
    )
    payment.save!
    redirect_to session.url, status: :see_other
  end

  def success
    flash[:notice] = 'チケットを購入しました'
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
