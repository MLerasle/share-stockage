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
  
  # def new
  #   @advert = Advert.new
  # end
  
  # def create
  #   @advert = Advert.new(advert_params)
  #   @advert.user_id = current_user.id
  #
  #   respond_to do |format|
  #     if @advert.save
  #       format.html { redirect_to new_advert_picture_path(@advert), notice: 'Merci! Votre annonce nous a bien été transmise. Elle apparaitra sur le site une fois validée.' }
  #       format.json { render json: @advert, status: :created, location: @advert }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @advert.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  def create
    @advert = current_user.adverts.new
    @advert.save(validate: false)
    redirect_to advert_step_path(@advert, Advert.form_steps.first)
  end
  
  # def edit
  #   unless @advert.user == current_user
  #     flash[:alert] = "Vous n'êtes pas autorisé à accéder à cette page."
  #     redirect_to advert_path(@advert)
  #   end
  # end
  
  # def update
  #   if @advert.update_attributes(advert_params)
  #     redirect_to user_path(current_user)
  #   else
  #     flash[:alert] = "Une erreur est survenue durant la mise à jour. Veuillez réessayer s'il vous plaît. Si le problème persiste, n'hésitez pas à contacter le support."
  #     redirect_to user_path(current_user)
  #   end
  # end
  
  def activate
    return redirect_to edit_advert_path(@advert) unless current_user == @advert.user
    @advert.update_attributes(activated: !@advert.activated)
    if @advert.activated
      flash[:notice] = "Votre annonce a été activée avec succès! Vous pouvez la désactiver à tout moment."
    else
      flash[:notice] = "Votre annonce a été désactivée avec succès! Vous pouvez la réactiver à tout moment."
    end
    redirect_to user_path(current_user)
  end
  
  def destroy
    @advert.destroy
    redirect_to adverts_path
  end
  
  private
  
  def find_advert
    @advert = Advert.find(params[:id])
  end
  
  def advert_params
    params.require(:advert).permit(:address, :area, :price, :advert_type, :user, :validated, :activated, :title, :light, :elevator, :concierge, :car_access, :access_type, :description, :height)
  end
end
