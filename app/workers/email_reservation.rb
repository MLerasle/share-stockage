class EmailReservation
  include Sidekiq::Worker

  def perform(user_id, subject, body)
    user = User.find(user_id)
    UserMailer.contact_announcer(user, subject, body).deliver
  end
end