class EvaluationsController < ApplicationController
  def create
    @advert = Advert.find(params[:advert])
    
    if @advert.authorize_evaluation_for_user?(current_user)
      @evaluation = @advert.evaluations.new(evaluation_params)
      @evaluation.user = current_user
      if @evaluation.save
        flash[:notice] = "Votre évaluation a bien été prise en compte. Elle apparaîtra sur le site une fois validée par notre équipe."
      else
        flash[:alert] = "Les données saisies sont incorrectes. Merci de réessayer."
      end
    else
      flash[:alert] = "Vous n'êtes pas autorisé à laisser une évaluation pour cette annonce. Vous devez pour cela avoir réservé l'espace au moins une fois!"
    end
    redirect_to advert_path(@advert)
  end
  
  private
  
  def evaluation_params
    params.permit(:user_id, :advert_id, :score, :comment)
  end
end