class FeedbackEmail
  include Sidekiq::Worker

  def perform(advert_id, advert_user_id, reservation_user_id)
    advert = Advert.find(advert_id)
    advert_user = User.find(advert_user_id)
    reservation_user = User.find(reservation_user_id)
    UserMailer.reservation_feedback(advert, reservation_user).deliver
    UserMailer.advert_feedback(advert_user).deliver
  end
end