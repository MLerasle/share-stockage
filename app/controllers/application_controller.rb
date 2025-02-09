class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :admin_user
  after_filter :store_location

  def admin_user
    @admin_user ||= User.where(email: ENV["admin_email"]).first
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :avatar) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :avatar) }
  end
  
  private
  
  def store_location
    return unless request.get? 
    if (!request.fullpath.match("/mon-compte") && !request.xhr?)
      session[:previous_url] = request.fullpath if request.format == "text/html" || request.content_type == "text/html"
    end
  end

  def after_sign_in_path_for(resource)
    return root_path if resource.sign_in_count == 1
    session[:previous_url] || root_path
  end
  
  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end
end
