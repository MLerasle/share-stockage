class Users::PasswordsController < Devise::PasswordsController
  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    Rails.logger.info("--- Call password controller")
    users_pending_password_path
  end
end