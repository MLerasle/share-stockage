# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://sharestockage.ch"

SitemapGenerator::Sitemap.create do
  add faq_path
  add cgu_path
  add help_path

  add articles_path, changefreq: 'weekly'
  Article.find_each do |article|
    add article_path(article.slug), lastmod: article.updated_at
  end

  add adverts_path
  Advert.find_each do |advert|
    add advert_path(advert.slug), lastmod: advert.updated_at
  end

  add new_user_session_path
  add new_user_registration_path
  
  # resource: http://www.cookieshq.co.uk/posts/creating-a-sitemap-with-ruby-on-rails-and-upload-it-to-amazon-s3/
end
