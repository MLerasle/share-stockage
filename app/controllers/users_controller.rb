class UsersController < ApplicationController
  before_action :authenticate_user!, except: :pending_password
  before_action :find_user, except: :pending_password
  
  def show
  end
  
  def owner_space
  end
  
  def lodger_space
  end

  def pending_password
    return redirect_to root_url if current_user
  end
  
  private
  
  def find_user
    @user = current_user
  end
end