class Category < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged
  has_and_belongs_to_many :articles
end