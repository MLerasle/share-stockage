class Picture < ActiveRecord::Base
  belongs_to :advert
  has_attached_file :image, 
    styles: { large: "650x470!", medium: "180x150!" },
    path: Rails.env.production? ? "adverts/:id/:style/:filename" : ":rails_root/public/images/:id/:style/:filename",
    url: Rails.env.production? ? ':s3_domain_url' : '/images/:id/:style/:filename',
    use_timestamp: false
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
