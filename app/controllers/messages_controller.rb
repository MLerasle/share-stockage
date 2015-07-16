class MessagesController < ApplicationController
  before_action :authenticate_user!
 
  # def new
  # end
 
  def create
    @resource = if params[:advert_id].present?
      Advert.find(params[:advert_id])
    elsif params[:reservation_id].present?
      Reservation.find(params[:reservation_id])
    end
    recipients = User.where(id: @resource.user_id)
    if current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
      NotificationEmail.perform_async(@resource.user_id)
      flash[:notice] = "Votre message a bien été envoyé."
    else
      flash[:alert] = "Une erreur est survenue durant l'envoi de votre message. Veuillez réessayer s'il vous plaît ou nous contacter si le problème persiste."
    end
    if @resource.is_a?(Advert)
      redirect_to advert_path(@resource)
    else
      redirect_to edit_advert_path(@resource.advert)
    end
  end
end