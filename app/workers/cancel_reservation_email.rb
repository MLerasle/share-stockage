class CancelReservationEmail
  include Sidekiq::Worker

  def perform(user_id, reservation_id)
    user = User.find(user_id)
    reservation = Reservation.find(reservation_id)
    UserMailer.cancel_reservation(user, reservation).deliver
  end
end