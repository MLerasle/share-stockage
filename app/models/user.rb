class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_messageable
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :accept_cgu, presence: true
  has_many :adverts, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :evaluations
  has_attached_file :avatar, styles: { thumb: "100x100#" }, 
                             default_url: ->(attachment) { ActionController::Base.helpers.asset_path('user.png') },
                             path: "users/:id/:style/avatar",
                             url: ':s3_domain_url',
                             use_timestamp: false
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def mailboxer_email(object)
    email
  end

  def name
    username
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

  def evaluations_score
    return 0 if self.total_evaluation == 0
    total_score = 0.0
    self.adverts.each do |advert|
      total_score += advert.evaluations.where(validated: true).sum(:score).to_f
    end
    result = (total_score / self.total_evaluation.to_f).to_f.round(1)
    result = result % 1 == 0 ? result.to_i : result.to_f
  end

  def total_evaluation
    total = 0
    self.adverts.each do |advert|
      total += advert.evaluation_number
    end
    total
  end
  
  def admin?
    email == ENV["admin_email"]
  end
end
