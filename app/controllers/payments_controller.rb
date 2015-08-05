class PaymentsController < ApplicationController
  def create
    # Amount in cents
    @amount = (params[:amount].to_f * 100).to_i
    reservation = Reservation.find(params[:reservation_id])
    advert = reservation.advert

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      card:  params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,
      amount:       @amount,
      description:  "Règlement de #{customer.email} pour réservation #{reservation.id}",
      currency:     'chf'
    )
    
    reservation.update_attributes(paid: true, charge_id: charge.id)
    UserMailer.new_reservation(reservation).deliver
    UserMailer.pending_reservation(reservation).deliver
    
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to payment_advert_reservation_path(advert, reservation)
  end
end
