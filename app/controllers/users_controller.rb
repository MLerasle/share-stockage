class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
  
  def show
  end
  
  def owner_space
  end
  
  def lodger_space
  end
  
  private
  
  def find_user
    @user = current_user
  end
end