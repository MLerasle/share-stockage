module ApplicationHelper
  include FoundationRailsHelper::FlashHelper
  
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def full_title(page_title)
    base_title = "Share Stockage"
    page_title.empty? ?  base_title : "#{base_title} | #{page_title}"
  end
end
