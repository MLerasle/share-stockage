class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :accept_cgu, presence: true
  has_many :adverts, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :evaluations
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def can_be_destroyed
    reservations = Reservation.includes(:advert).where(validated: true).where("reservations.user_id = ? OR adverts.user_id = ?", self.id, self.id).references(:advert)
    reservations.each do |r|
      return false if (r.start_date..r.end_date).include?(Date.today)
    end
    true
  end
end
