class AdvertsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :unavailable_dates, :new]
  before_filter :find_advert, except: [:index, :new, :create, :preview]
  
  def index
    params[:filter] ||= {}
    params[:filter][:sorting] ||= "created_at DESC"
    @adverts = Advert.where(validated: true, activated: true).order(params[:filter][:sorting]).page(params[:page]).per(10)
    @adverts = @adverts.for_filter(params[:filter]) unless params[:filter].blank?
    my_adverts_address = []
    @adverts.each do |a|
      my_adverts_address << { address: a.full_address, data: "<h6 style='font-weight: bold; color:rgb(57,141,183)'>#{a.type_name} de #{a.volume} m³</h6><h6>#{a.full_address}</h6>", tag: "/garde-meuble/#{a.slug}" }
    end
    @my_json_address = my_adverts_address.to_json
    render layout: 'search_adverts'
  end
  
  def show
  end

  def new
    return redirect_to users_sign_up_path unless current_user
    @advert = current_user.adverts.new
  end

  def create
    @advert = current_user.adverts.new(advert_params)
    if @advert.save
      UserMailer.new_advert_mail(@advert).deliver
      redirect_to new_advert_picture_path(@advert)
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @advert.update_attributes(advert_params)
      redirect_to new_advert_picture_path(@advert)
    else
      render action: :edit
    end
  end
  
  def activate
    return redirect_to edit_advert_path(@advert) unless current_user == @advert.user
    @advert.update_attributes(activated: !@advert.activated)
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    if current_user == @advert.user and @advert.is_deletable?
      @advert.destroy
      flash[:notice] = "Votre annonce a bien été supprimée."
    else
      flash[:alert] = "Vous n'êtes pas autorisé à supprimer cette annonce. Consulter les FAQ pour connaître les conditions de suppression d'une annonce."
    end
    redirect_to owner_space_users_path
  end

  def unavailable_dates
    @dates = @advert.unavailable_dates
    respond_to do |format|
      format.json { render json: @dates }
    end
  end

  def preload_pictures
    if @advert.pictures
      images = []
      @advert.pictures.each do |pic|
        images << { id: pic.id, name: pic.image_file_name, size: pic.image_file_size, url: pic.image.url }
      end
    end
    respond_to do |format|
      if images.any?
        format.json { render json: images }
      else
        format.json { render json: {error: "No images"} }
      end
    end
  end
  
  private
  
  def find_advert
    @advert = Advert.friendly.find(params[:id])
  end
  
  def advert_params
    params.require(:advert).permit(:address, :city, :country, :area, :price, :advert_type, :user, :activated, :title, :light, :elevator, :concierge, :car_access, :access_type, :description, :height, :slug, :security, :preservation, :floor, :complete, :nip)
  end
end
