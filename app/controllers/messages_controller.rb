class MessagesController < ApplicationController
  before_action :authenticate_user!
 
  def new
  end
 
  def create
    @advert = Advert.find(params[:advert_id])
    recipients = User.where(id: @advert.user_id)
    current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:notice] = "Votre demande a bien été envoyée au propriétaire."
    redirect_to advert_path(@advert)
  end
end