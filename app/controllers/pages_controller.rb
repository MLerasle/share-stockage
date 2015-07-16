class PagesController < ApplicationController
  def index
  end
  
  def faq
  end
  
  def cgu
  end
  
  def help
  end
  
  def pending_signup
    return redirect_to root_url if current_user and current_user.confirmed_at.present?
  end
end
