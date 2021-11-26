class Students::TicketsController < ApplicationController
  before_action :authenticate_student!

  def new
  end

  def create
    ticket_qty = params[:qty].to_i
    product = Student::INSTANT_TICKET_PRODUCTS[ticket_qty]
    customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken]
    })
    charge = Stripe::Charge.create({
      customer: customer.id,
      amount: product[:amount],
      description: product[:description],
      currency: product[:currency]
    })
    current_student.tickets += ticket_qty
    current_student.save!
    redirect_to new_students_tickets_path, notice: 'チケットを購入しました'
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_students_tickets_path
  end

end
