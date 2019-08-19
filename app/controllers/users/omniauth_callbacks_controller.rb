class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in(@user)
    # path = if @user.sign_in_count == 1
    #   welcome_path
    # else
    #   session[:previous_url] || root_url
    # end
    # redirect_to path
    redirect_to session[:previous_url] || root_url
  end

  def google
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user
  end
end