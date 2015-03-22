class Evaluation < ActiveRecord::Base
  belongs_to :user
  belongs_to :advert
  
  default_value_for :validated, false
  
  validates :user_id, presence: true
  validates :advert_id, presence: true
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :comment, presence: true
  
  def self.validated
    where(validated: true)
  end
end