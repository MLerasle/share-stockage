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
  end
  
  def contact_user
    @advert = Advert.find(params[:advert])
    @reservation = Reservation.find(params[:reservation])
    if EmailReservation.perform_async(@reservation.user_id, params[:subject], params[:body])
      flash[:notice] = "Votre demande de réservation a bien été envoyée au propriétaire."
      redirect_to advert_path(@advert)
    else
      flash[:alert] = "Une erreur est survenue durant l'envoi de votre mail. Veuillez réessayer s'il vous plaît. Si le problème persiste, n'hésitez pas à contacter le support."
      redirect_to advert_path(@advert)
    end
  end
  
  # def contact_announcer
  #   @advert = Advert.find(params[:advert])
  #   if EmailAnnouncer.perform_async(@advert.id, params[:subject], params[:body])
  #     flash[:notice] = "Votre demande de renseignements a bien été envoyée au propriétaire."
  #     redirect_to advert_path(@advert)
  #   else
  #     flash[:alert] = "Une erreur est survenue durant l'envoi de votre mail. Veuillez réessayer s'il vous plaît. Si le problème persiste, n'hésitez pas à contacter le support."
  #     redirect_to advert_path(@advert)
  #   end
  # end
end
