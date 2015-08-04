class AddPaidToReservations < ActiveRecord::Migration
  def up
    add_column :reservations, :paid, :boolean, default: false
  end
  
  def down
    remove_column :reservations, :paid
  end
end
