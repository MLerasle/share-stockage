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
    
    reservation.update_attributes(paid: true)
    recipients = User.where(id: advert.user_id)
    admin_user.send_message(recipients, reservation.email_ask[:body], reservation.email_ask[:subject]).conversation
    advert_user = User.find(advert.user_id)
    UserMailer.notify_user(advert_user).deliver
    UserMailer.pending_reservation(reservation).deliver
    
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to payment_advert_reservation_path(advert, reservation)
  end
end
