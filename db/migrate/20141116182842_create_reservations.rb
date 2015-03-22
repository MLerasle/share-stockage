class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :advert_id
      t.boolean :validated, default: false
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
