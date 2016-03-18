class AddRemotePhotoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remote_photo, :string
  end
end
