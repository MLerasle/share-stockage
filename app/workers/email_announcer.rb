class EmailAnnouncer
  include Sidekiq::Worker

  def perform(advert_id, subject, body)
    advert = Advert.find(advert_id)
    user = User.find(advert.user_id)
    UserMailer.contact_announcer(advert, user, subject, body).deliver
  end
end