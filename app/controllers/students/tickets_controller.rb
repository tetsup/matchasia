class Students::TicketsController < ApplicationController
  before_action :authenticate_student!

  def new
  end

  def create
    ticket_qty = params[:qty].to_i
    current_student.buy_tickets!(ticket_qty, params[:stripeEmail], params[:stripeToken])
    current_student.save!
    redirect_to new_students_tickets_path, notice: 'チケットを購入しました'
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_students_tickets_path
  end
end
