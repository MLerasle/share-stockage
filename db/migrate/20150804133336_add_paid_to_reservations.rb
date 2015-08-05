class AddPaidToReservations < ActiveRecord::Migration
  def up
    add_column :reservations, :paid, :boolean, default: false
    add_column :reservations, :charge_id, :string
  end
  
  def down
    remove_column :reservations, :paid
    remove_column :reservations, :charge_id
  end
end
