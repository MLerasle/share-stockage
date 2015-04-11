class AdvertsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_filter :find_advert, except: [:index, :new, :create, :preview]
  
  def index
    @adverts = Advert.where(validated: true, activated: true).order("created_at DESC").page(params[:page]).per(12)
    @adverts = @adverts.for_filter(params[:filter]) unless params[:filter].blank?
    my_adverts_address = []
    @adverts.each do |a|
      my_adverts_address << { address: a.address, data: a.address, tag: "/adverts/#{a.id}" }
    end
    @my_json_address = my_adverts_address.to_json
  end
  
  def show
  end

  def create
    existing_advert = current_user.adverts.where("adverts.created_at >= ?", Time.now - 5).last if current_user.adverts.where(created_at: Time.now).any?
    return redirect_to advert_step_path(existing_advert, Advert.form_steps.first) if existing_advert
    @advert = current_user.adverts.new
    @advert.save(validate: false) unless current_user.adverts.where(created_at: Time.now).any?
    redirect_to advert_step_path(@advert, Advert.form_steps.first)
  end
  
  def activate
    return redirect_to edit_advert_path(@advert) unless current_user == @advert.user
    @advert.update_attributes(activated: !@advert.activated)
    if @advert.activated
      flash[:notice] = "Votre annonce a été activée avec succès! Vous pouvez la désactiver à tout moment."
    else
      flash[:notice] = "Votre annonce a été désactivée avec succès! Vous pouvez la réactiver à tout moment."
    end
    redirect_to edit_user_registration_path(current_user)
  end
  
  def destroy
    if current_user == @advert.user and @advert.is_deletable?
      @advert.destroy
      flash[:alert] = "Votre annonce a bien été supprimée."
    else
      flash[:alert] = "Vous n'êtes pas autorisé à supprimer cette annonce. Consulter les FAQ pour connaître les conditions de suppression d'une annonce."
    end
    redirect_to edit_user_registration_path(current_user)
  end

  def unavailable_dates
    @dates = @advert.unavailable_dates
    respond_to do |format|
      format.json { render json: @dates }
    end
  end
  
  private
  
  def find_advert
    @advert = Advert.friendly.find(params[:id])
  end
  
  def advert_params
    params.require(:advert).permit(:address, :area, :price, :advert_type, :user, :validated, :activated, :title, :light, :elevator, :concierge, :car_access, :access_type, :description, :height)
  end
end
