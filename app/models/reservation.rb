class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :advert
  default_value_for :validated, false
  validates :start_date, presence: true
  validates :end_date, presence: true
  
  def self.json_format
    reservations = []
    self.all.each do |reservation|
      reservations << { title: reservation.validated ? 'Réservé' : 'En attente', start: reservation.start_date, end: reservation.end_date, allDay: true }
    end
    reservations
  end
  
  def self.pending
    where(validated: false)
  end
  
  def duration
    (end_date - start_date + 1).to_i
  end
  
  def price
  	advert.daily_price * duration
  end
end
