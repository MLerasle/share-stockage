class AddCanceledToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :canceled, :boolean, default: false
  end
end
