class ValidateReservationEmail
  include Sidekiq::Worker

  def perform(owner_id, user_id, reservation_id)
    user = User.find(user_id)
    owner = User.find(owner_id)
    reservation = Reservation.find(reservation_id)
    UserMailer.validate_reservation(user, reservation).deliver
    UserMailer.validate_reservation_owner(owner, reservation).deliver
  end
end