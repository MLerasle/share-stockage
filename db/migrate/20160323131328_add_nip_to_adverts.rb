class AddNipToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :nip, :integer
  end
end
