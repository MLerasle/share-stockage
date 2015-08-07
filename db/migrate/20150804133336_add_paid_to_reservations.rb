class AddPaidToReservations < ActiveRecord::Migration
  def up
    add_column :reservations, :paid, :boolean, default: false
    add_column :reservations, :customer_id, :string
    add_column :reservations, :commission_amount, :decimal, precision: 8, scale: 2
  end
  
  def down
    remove_column :reservations, :paid
    remove_column :reservations, :customer_id
    remove_column :reservations, :commission_amount
  end
end
