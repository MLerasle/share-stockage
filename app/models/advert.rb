class Advert < ActiveRecord::Base
  include FriendlyId
  friendly_id :slug_candidates, use: :slugged

  cattr_accessor :form_steps do
    %w(general location description price)
  end
  attr_accessor :form_step

  belongs_to :user
  has_many :reservations
  has_many :evaluations
  has_many :pictures, dependent: :destroy
  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?
  
  default_value_for :validated, false
  default_value_for :activated, true
  default_value_for :light, false
  default_value_for :concierge, false
  default_value_for :car_access, false
  default_value_for :elevator, false
  default_value_for :access_type, 0
  default_value_for :complete, false
  default_value_for :slug do
    SecureRandom.uuid
  end
  default_value_for :from_date do
    Date.today
  end

  validates :title, :area, :height, :advert_type, presence: true, if: -> { required_for_step?(:general) }
  validates :area, :height, numericality: true, if: -> { required_for_step?(:general) }
  validates :address, :city, :country, presence: true, if: -> { required_for_step?(:location) }
  validates :description, :access_type, :floor, :preservation, :security, presence: true, if: -> { required_for_step?(:description) }
  validates :price, presence: true, numericality: true, if: -> { required_for_step?(:price) }

  def slug_candidates
    [
      [:title],
      [:title, :address],
      [:title, :address, :type_name],
      [:title, :address, :type_name, :id]
    ]
  end

  def starting_date
    from_date > Date.today ? from_date : Date.today
  end
  
  def unavailable_dates
    if Date.today < from_date
      [{ title: "Indisponible", start: Date.today, end: from_date, allDay: true }]
    else
      []
    end
  end

  def booked_dates
    dates  = []
    self.validated_reservations.each do |r|
      (r.start_date..r.end_date).each do |date|
        dates << date
      end
    end
    dates
  end

  def should_generate_new_friendly_id?
    return false unless self.validated
    validated_changed? || title_changed? || address_changed? || advert_type_changed? || price_changed? || super
  end
  
  def required_for_step?(step)
    # All fields are required if no form step is present
    # return true if form_step.nil?
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
    (reservation.nil? or reservation.end_date > Date.today) ? false : true
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
  
  def daily_price
    BigDecimal.new((price / 30.0).to_s).round(2)
  end

  def price_with_commission
    BigDecimal.new((price * 1.08).to_s).round(2)
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

  def complete_hr
    complete ? "Espace complet" : "Espace partagé"
  end

  def security_hr
    string = security == 1 ? "porte verrouillée" : "portes verrouillées"
    "#{security} #{string}"
  end

  def preservation_hr
    if preservation == 0
      "De base (résisitant à l'humidité)"
    elsif preservation == 1
      "Normale (cartons)"
    elsif preservation == 2
      "Haute (électronique)"
    else
      "Non renseigné"
    end
  end
  
  def reservations_waiting_validation
    self.reservations.where(validated: false, canceled: false)
  end
  
  def validated_reservations
    self.reservations.where(validated: true)
  end

  def running_reservation
    self.validated_reservations.where("start_date <= ? and end_date >= ?", Date.today, Date.today).last
  end
  
  def has_running_reservations?
    # self.validated_reservations.where("start_date <= ? and end_date >= ?", Date.today, Date.today).any?
    running_reservation.present?
  end
  
  def is_deletable?
    self.reservations_waiting_validation.empty? and !self.has_running_reservations?
  end
  
  def activate_title
    self.activated ? "Désactiver l'annonce" : "Activer l'annonce"
  end

  def full_address
    "#{self.address}, #{self.city}, #{self.country}"
  end
end
