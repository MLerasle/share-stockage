class RegistrationsController < Devise::RegistrationsController
  private
 
  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :accept_cgu)
  end
 
  def account_update_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password)
  end
  
  protected

  def after_inactive_sign_up_path_for(resource)
    '/pending_signup'
  end
end