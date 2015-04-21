class RegistrationsController < Devise::RegistrationsController
  def destroy
    unless current_user and current_user.can_be_destroyed and (current_user == resource or current_user.admin)
      flash[:alert] = "Vous n'êtes pas autorisé à supprimer ce compte."
      return redirect_to user_path(resource)
    end
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :alert, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to new_user_registration_path }
  end

  private
 
  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :accept_cgu, :avatar, :first_name, :last_name)
  end
 
  def account_update_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password, :avatar, :first_name, :last_name)
  end
  
  protected

  def after_inactive_sign_up_path_for(resource)
    '/pending_signup'
  end

  def after_update_path_for(resource)
    flash[:notice] = "Votre compte a bien été mis à jour."
    edit_user_registration_path(resource)
  end
end