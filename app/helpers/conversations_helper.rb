module ConversationsHelper
  def mailbox_section(title, type, current_box, opts = {})
    opts[:class] = opts.fetch(:class, '')
    opts[:class] += ' active' if type.downcase == current_box
    content_tag :li, link_to(title, conversations_path(box: type.downcase)), opts
  end
end