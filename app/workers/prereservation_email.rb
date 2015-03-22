class PrereservationEmail
  include Sidekiq::Worker

  def perform(user_id, advert_id)
    user = User.find(user_id)
    advert = Advert.find(advert_id)
    UserMailer.prereservation_email(user, advert).deliver
  end
end