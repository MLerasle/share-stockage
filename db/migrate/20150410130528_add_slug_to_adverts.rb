class AddSlugToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :slug, :string, null: false
    add_index :adverts, :slug, unique: true
  end
end
