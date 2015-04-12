<% if @advert.activated %>
  $("#activation_link").html("<%= escape_javascript(link_to @advert.activate_title, activate_advert_path(@advert), method: :put, remote: true, id: 'activation_link', class: 'button radius alert') %>");
<% else %>
  $("#activation_link").html("<%= escape_javascript(link_to @advert.activate_title, activate_advert_path(@advert), method: :put, remote: true, id: 'activation_link', class: 'button radius success') %>");
<% end %>