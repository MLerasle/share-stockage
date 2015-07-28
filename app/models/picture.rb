class Picture < ActiveRecord::Base
  belongs_to :advert
  has_attached_file :image, 
    styles: { large: "650x470!", medium: "180x150!" },
    path: "adverts/:id/:style/:filename",
    url: ':s3_domain_url',
    use_timestamp: false
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
