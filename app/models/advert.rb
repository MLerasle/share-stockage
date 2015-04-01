class Advert < ActiveRecord::Base
  belongs_to :user
  has_many :reservations
  has_many :evaluations
  has_many :pictures, dependent: :destroy
  geocoded_by :full_address
  after_validation :geocode, :if => :address_changed?
  
  default_value_for :validated, false
  default_value_for :activated, true
  default_value_for :light, false
  default_value_for :concierge, false
  default_value_for :car_access, false
  default_value_for :elevator, false
  default_value_for :access_type, 0
  
  validates :title, presence: true
  validates :city, presence: true
  validates :address, presence: true
  validates :area, presence: true, numericality: true
  validates :price, presence: true, numericality: true
  validates :advert_type, presence: true
  validates :description, presence: true
  validates :height, presence: true, numericality: true
  validates :access_type, presence: true
  
  
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
    
    if filter["city"].present? and filter["kilometers"].present? and filter["kilometers"].to_i > 9
      result = result.near(filter['city'], filter['kilometers'].to_i, units: :km)
    elsif filter["city"].present?
      result = result.near(filter['city'], 10, units: :km)
    end
    result = result.where(advert_type: filter["advert_type"]) unless filter["advert_type"].blank?
    result = result.where("id NOT IN (SELECT advert_id FROM reservations WHERE advert_id IS NOT NULL AND reservations.start_date < ? AND reservations.end_date > ?)", filter["end_date"], filter["start_date"])
    result
  end
  
  def volume
    (area * height).round
  end
  
  def full_address
    "#{address}, #{city}"
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
