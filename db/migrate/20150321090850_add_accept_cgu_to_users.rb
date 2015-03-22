class AddAcceptCguToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accept_cgu, :boolean, default: false
  end
end
