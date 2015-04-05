class Adverts::StepsController < ApplicationController
  include Wicked::Wizard
  steps *Advert.form_steps
  before_action :authenticate_user!

  def show
    @advert = Advert.find(params[:advert_id])
    return redirect_to new_advert_picture_path(@advert) if step == Wicked::FINISH_STEP
    render_wizard
  end

  def update
    @advert = Advert.find(params[:advert_id])
    @advert.update_attributes(advert_params(step))
    render_wizard @advert
  end
  
  private
  
  def advert_params(step)
    permitted_attributes = case step
      when "general"
        [:title, :area, :height, :advert_type]
      when "location"
        [:address]
      when "description"
        [:description, :access_type, :light, :elevator, :concierge, :car_access]
      when "price"
        [:price]
      end

    params.require(:advert).permit(permitted_attributes).merge(form_step: step)
    # Manque user, activated, validated
  end
end