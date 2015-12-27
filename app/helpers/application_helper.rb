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

  def wizard_menu(step, icon, title)
    content = ""
    content += content_tag(:div, class: "panel wizard_menu", id: step) do
      content_tag(:h4) do
        concat content_tag(:i, "", class: "fa fa-#{icon}")
        concat " #{title}"
      end
    end
    content.html_safe
  end
end
