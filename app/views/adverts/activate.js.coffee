<% if @advert.activated %>
  $('#activation_link_<%= @advert.id %>').html("<%= escape_javascript(link_to @advert.activate_title, activate_advert_path(@advert), method: :put, remote: true, id: 'activation_link_@advert.id', class: 'button radius alert small') %>")
<% else %>
  $('#activation_link_<%= @advert.id %>').html("<%= escape_javascript(link_to @advert.activate_title, activate_advert_path(@advert), method: :put, remote: true, id: 'activation_link_@advert.id', class: 'button radius success small') %>")
<% end %>