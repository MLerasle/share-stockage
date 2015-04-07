class Advert < ActiveRecord::Base
  cattr_accessor :form_steps do
    %w(general location description price)
  end
  attr_accessor :form_step

  belongs_to :user
  has_many :reservations
  has_many :evaluations
  has_many :pictures, dependent: :destroy
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  
  default_value_for :validated, false
  default_value_for :activated, false
  default_value_for :light, false
  default_value_for :concierge, false
  default_value_for :car_access, false
  default_value_for :elevator, false
  default_value_for :access_type, 0

  validates :title, :area, :height, :advert_type, presence: true, if: -> { required_for_step?(:general) }
  validates :area, :height, numericality: true, if: -> { required_for_step?(:general) }
  validates :address, presence: true, if: -> { required_for_step?(:location) }
  validates :description, :access_type, :floor, :preservation, :security, presence: true, if: -> { required_for_step?(:description) }
  validates :price, presence: true, numericality: true, if: -> { required_for_step?(:price) }
  
  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?
    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    return true if self.form_steps.index(step.to_s) == self.form_steps.index(form_step)
  end

  def area=(area)
    write_attribute(:area, area.gsub(',', '.'))
  end
  
  def height=(height)
    write_attribute(:height, height.gsub(',', '.'))
  end
  
  def price=(price)
    write_attribute(:price, price.gsub(',', '.'))
  end
  
  def evaluation_average
    return 0 if self.evaluation_number == 0
    result = (self.evaluations.where(validated: true).sum(:score).to_f / self.evaluation_number.to_f).to_f.round(1)
    result = result % 1 == 0 ? result.to_i : result.to_f
  end
  
  def evaluation_number
    self.evaluations.where(validated: true).count
  end
  
  def authorize_evaluation_for_user?(user)
    return false if user.nil?
    reservation = self.reservations.where(validated: true, user_id: user.id).last
    reservation.nil? ? false : true
  end
  
  def self.for_filter(filter)
    result = self.all
    
    if filter["address"].present? and filter["kilometers"].present? and filter["kilometers"].to_i > 9
      result = result.near(filter['address'], filter['kilometers'].to_i, units: :km)
    elsif filter["address"].present?
      result = result.near(filter['address'], 10, units: :km)
    end
    result = result.where(advert_type: filter["advert_type"]) unless filter["advert_type"].blank?
    result = result.where("id NOT IN (SELECT advert_id FROM reservations WHERE advert_id IS NOT NULL AND reservations.start_date < ? AND reservations.end_date > ?)", filter["end_date"], filter["start_date"])
    result
  end
  
  def volume
    (area * height).round
  end
  
  def light_hr
    light ? "Oui" : "Non"
  end
  
  def concierge_hr
    concierge ? "Oui" : "Non"
  end
  
  def car_access_hr
    car_access ? "Oui" : "Non"
  end
  
  def elevator_hr
    elevator ? "Oui" : "Non"
  end
  
  def access_type_hr
    access_type == 0 ? "Accès sur rendez-vous" : "Accès permanent"
  end
  
  def type_name
    case self.advert_type
    when 1
      "Box"
    when 2
      "Cave"
    when 3
      "Garage"
    when 4
      "Grenier"
    else
      "Autre"
    end
  end
  
  def reservations_waiting_validation
    self.reservations.where(validated: false)
  end
  
  def validated_reservations
    self.reservations.where(validated: true)
  end
  
  def activate_title
    self.activated ? "Désactiver l'annonce" : "Activer l'annonce"
  end
end
