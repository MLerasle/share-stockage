class PagesController < ApplicationController
  def index
  end
  
  def faq
  end
  
  def cgu
  end
  
  def help
  end
  
  def welcome
    return redirect_to root_url if current_user and current_user.sign_in_count > 1
  end

  # Landing pages pour pubs Facebook
  def complement_revenu
    render layout: 'landing'
  end

  def espace_libre
    render layout: 'landing'
  end

  def garde_meuble_entre_particuliers
    render layout: 'landing'
  end
end
