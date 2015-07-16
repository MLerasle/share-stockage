class NotificationEmail
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.notify_user(user).deliver
  end
end