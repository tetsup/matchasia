class StudentsController < ApplicationController
  before_action :authenticate_student!

  def new_tickets
  end

  def add_tickets
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
    redirect_to new_tickets_students_path, notice: 'チケットを購入しました'
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_tickets_students_path
  end

end
