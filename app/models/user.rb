class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :accept_cgu, presence: true
  has_many :adverts, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :evaluations
  has_attached_file :avatar, styles: { thumb: "50x50#" }, 
                             default_url: ->(attachment) { ActionController::Base.helpers.asset_path('user.jpg') },
                             path: "users/:id/:style/avatar",
                             url: ':s3_domain_url',
                             use_timestamp: false
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google]
         
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def username
    "#{first_name.capitalize}" if first_name
  end

  def self.from_omniauth(auth)
    if user = User.where(email: auth.info.email).first
      return user
    end
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.remote_photo = auth.info.image
      user.password = Devise.friendly_token[0,20]
      user.accept_cgu = true
      user.skip_confirmation!
      user.save!
    end
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

  def pending_reservations
    Reservation.includes(:advert).where("adverts.user_id = ? and reservations.validated = ? and canceled = ?", self.id, 0, 0).references(:advert)
  end
  
  def admin?
    email == ENV["admin_email"]
  end
end
