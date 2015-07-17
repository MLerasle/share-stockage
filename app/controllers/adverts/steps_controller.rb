class Adverts::StepsController < ApplicationController
  include Wicked::Wizard
  steps *Advert.form_steps
  before_action :authenticate_user!
  before_action :find_advert
  before_action :check_user

  def show
    return redirect_to new_advert_picture_path(@advert) if step == Wicked::FINISH_STEP
    render_wizard
  end

  def update
    @advert.update_attributes(advert_params(step))
    render_wizard @advert
  end
  
  private
  
  def advert_params(step)
    permitted_attributes = case step
      when "general"
        [:title, :area, :height, :advert_type, :complete, :from_date]
      when "location"
        [:address]
      when "description"
        [:description, :access_type, :light, :elevator, :concierge, :car_access, :floor, :preservation, :security]
      when "price"
        [:price]
      end

    params.require(:advert).permit(permitted_attributes).merge(form_step: step)
  end

  def find_advert
    @advert = Advert.friendly.find(params[:advert_id])
  end
  
  def check_user
    return redirect_to root_path unless current_user == @advert.user
  end
end