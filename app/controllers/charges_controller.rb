class ChargesController < ApplicationController
  def new
  end

  def create
    # Amount in cents
    @amount = (params[:amount].to_f * 100).to_i

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      card:  params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,
      amount:       @amount,
      description:  "Don de #{customer.email}",
      currency:     'chf'
    )
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end