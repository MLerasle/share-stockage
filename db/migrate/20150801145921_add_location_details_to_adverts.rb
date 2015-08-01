class AddLocationDetailsToAdverts < ActiveRecord::Migration
  def up
    add_column :adverts, :city, :string
    add_column :adverts, :country, :string
  end

  def down
    remove_column :adverts, :city
    remove_column :adverts, :country
  end
end
