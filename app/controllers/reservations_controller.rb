class ReservationsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_filter :find_advert
  before_filter :find_reservation, only: [:edit, :update, :preview_validate, :preview_cancel, :destroy, :validate, :cancel, :payment]
  
  def index
    @reservations = @advert.validated_reservations.json_format
    respond_to do |format|
      format.json { render json: @reservations }
    end
  end
  
  def pending
    @reservations = @advert.reservations_waiting_validation.json_format
    respond_to do |format|
      format.json { render json: @reservations }
    end
  end
  
  def create
    if !@advert.validated
      flash[:alert] = "Vous pourrez réserver cet espace une fois l'annonce validée."
      return redirect_to advert_path(@advert)
    end
    @reservation = @advert.reservations.new(reservation_params)
    if @advert.booked_dates.include?(@reservation.start_date) or @advert.booked_dates.include?(@reservation.end_date)
      flash[:alert] = "Cet espace n'est pas disponible aux dates sélectionnées. Veuillez vérifier la disponibilité de l'espace dans la section Calendrier."
      return redirect_to advert_path(@advert)
    end
    @reservation.user = current_user
    if @reservation.save
      flash[:notice] = "Votre demande de réservation a bien été prise en compte."
      redirect_to payment_advert_reservation_path(@advert, @reservation)
    else
      flash[:alert] = "Les données saisies pour votre réservation sont incorrectes. Veuillez vérifier que les dates choisies sont valides et réessayer."
      redirect_to advert_path(@advert)
    end
  end

  def payment
    return redirect_to advert_path(@advert) if @reservation.paid
  end
  
  def preview_validate
  end
  
  def validate
    return redirect_to owner_space_users_path if current_user != @advert.user or @reservation.validated
    if @reservation.update_attributes(validated: true)
      advert_user = User.find(@advert.user_id)
      reservation_user = User.find(@reservation.user_id)
      charge = Stripe::Charge.create(
        customer:     @reservation.customer_id,
        amount:       @reservation.commission_amount.to_i,
        description:  "Règlement de #{reservation_user.email} pour réservation #{@reservation.id}",
        currency:     'chf'
      )
      UserMailer.validate_reservation(reservation_user, @reservation).deliver
      UserMailer.validate_reservation_owner(advert_user, @reservation).deliver
      # FeedbackEmail.perform_at((@reservation.end_date.to_time + 10.hours).to_i, @reservation.advert_id, @reservation.advert.user_id, @reservation.user_id)
      flash[:notice] = "La réservation a bien été validée. Veuillez consulter vos mails pour obtenir un exemplaire du contrat de location."
    else
      flash[:alert] = "Une erreur est survenue durant la validation de la réservation. Veuillez réessayer s'il vous plaît. Si le problème persiste, n'hésitez pas à contacter le support."
    end
    redirect_to owner_space_users_path
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to payment_advert_reservation_path(advert, reservation)
  end
  
  def cancel
    return redirect_to owner_space_users_path if current_user != @advert.user or @reservation.canceled
    if @reservation.update_attributes(canceled: true)
      @reservation.update_attributes(paid: false, customer_id: nil, commission_amount: nil)
      UserMailer.cancel_reservation(@reservation).deliver
      flash[:notice] = "La réservation a bien été annulée. Un email a été envoyé au locataire pour l'en informer."
    else
      flash[:alert] = "Une erreur est survenue durant l'annulation de la réservation. Veuillez réessayer s'il vous plaît. Si le problème persiste, n'hésitez pas à contacter le support."
    end
    redirect_to owner_space_users_path
  end
  
  def preview_cancel
  end
  
  def edit
  end
  
  def update
    return redirect_to users_path if current_user != @reservation.user or @reservation.paid or @reservation.validated
    if @reservation.update_attributes(reservation_params)
      flash[:notice] = "Votre demande de modification concernant votre réservation a bien été prise en compte."
      redirect_to payment_advert_reservation_path(@advert, @reservation)
    else
      flash[:alert] = "Une erreur est survenue durant la mise à jour de votre réservation. Veuillez réessayer s'il vous plaît. Si le problème persiste, n'hésitez pas à contacter le support."
      redirect_to lodger_space_users_path
    end
  end
  
  def destroy
    return redirect_to lodger_space_users_path if current_user != @reservation.user or @reservation.paid or @reservation.validated
    if @reservation.destroy
      flash[:notice] = "La réservation a bien été supprimée"
    else
      flash[:alert] = "Une erreur est survenue durant la suppresison de la réservation. Veuillez réessayer s'il vous plaît. Si le problème persiste, n'hésitez pas à contacter le support."
    end
    redirect_to lodger_space_users_path
  end
  
  private
  
  def find_advert
    @advert = Advert.friendly.find(params[:advert_id])
  end
  
  def find_reservation
    @reservation = Reservation.find(params[:id])
  end
  
  def reservation_params
    params.require(:reservation).permit(:user_id, :advert_id, :start_date, :end_date, :validated, :paid)
  end
end
