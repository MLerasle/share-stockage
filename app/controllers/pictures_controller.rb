class PicturesController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_advert, except: :destroy
  
  def new
    if @advert.user != current_user
      flash[:alert] = "Vous n'êtes pas autorisé à accéder à cette page."
      redirect_to owner_space_users_path
    else
      @picture = @advert.pictures.new
    end
  end
 
  def create
    @picture = @advert.pictures.create(picture_params)
    if @picture.save
     render json: { fileID: @picture.id , message: "success" }, :status => 200
    else
     render json: { error: @picture.errors.full_messages.join(',')}, :status => 400
    end
  end
  
  def destroy
    @picture = Picture.find(params[:id])
    advert = @picture.advert
    
    respond_to do |format|
      if @picture.destroy
        format.json { render json: { message: "File deleted from server" } }
      else
        format.json { render json: { message: @picture.errors.full_messages.join(',') } }
      end
    end
  end 
   
  private
  
  def find_advert
    @advert = Advert.friendly.find(params[:advert_id])
  end
  
  def picture_params
    params.require(:picture).permit(:image)
  end 
end