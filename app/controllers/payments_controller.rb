class PaymentsController < ApplicationController
  def create
    # Amount in cents
    @amount = (params[:amount].to_f * 100).to_i
    reservation = Reservation.find(params[:reservation_id])
    advert = reservation.advert

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source:  params[:stripeToken]
    )
    
    reservation.update_attributes(paid: true, customer_id: customer.id, commission_amount: @amount)
    UserMailer.new_reservation(reservation).deliver
    UserMailer.pending_reservation(reservation).deliver
    
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to payment_advert_reservation_path(advert, reservation)
  end
end
