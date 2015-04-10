class PicturesController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_advert, except: :destroy
  
  def new
    # return redirect_to root_path if @advert.validated
    if @advert.user != current_user
      flash[:alert] = "Vous n'êtes pas autorisé à accéder à cette page."
      redirect_to edit_user_registration_path(current_user)
    else
      @picture = @advert.pictures.new
    end
  end
 
  def create
    return redirect_to root_path if @advert.validated
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
    if @picture.destroy
      if params[:delete_from].present? and params[:delete_from] == "edit"
        flash[:notice] = "Limage a été supprimé de votre annonce avec succès."
        redirect_to edit_advert_path(advert)
      else
        render json: { message: "File deleted from server" }
      end
    else
      if params[:delete_from].present? and params[:delete_from] == "edit"
        flash[:alert] = "Une erreur est survenue durant la suppression de l'image. Veuillez réessayer s'il vous plaît. Si le problème persiste, n'hésitez pas à contacter le support."
        redirect_to edit_advert_path(advert)
      else
        render json: { message: @picture.errors.full_messages.join(',') }
      end
    end
  end 
   
  private
  
  def find_advert
    @advert = Advert.find(params[:advert_id])
  end
  
  def picture_params
    params.require(:picture).permit(:image)
  end 
end