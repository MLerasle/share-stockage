class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.string :address
      t.string :city
      t.integer :advert_type
      t.decimal :area, precision: 8, scale: 2
      t.decimal :price, precision: 8, scale: 2
      t.decimal :height, precision: 8, scale: 2
      t.float :longitude
      t.float :latitude
      t.integer :user_id
      t.string :title
      t.boolean :validated, default: false
      t.boolean :activated, default: false
      t.boolean :light, default: false
      t.boolean :concierge, default: false
      t.boolean :car_access, default: false
      t.boolean :elevator, default: false
      t.integer :access_type
      t.text :description

      t.timestamps
    end
  end
end
