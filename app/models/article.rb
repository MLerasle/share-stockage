class Article < ActiveRecord::Base
  include FriendlyId
  friendly_id :title, use: :slugged
  has_and_belongs_to_many :categories
end