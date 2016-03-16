class AddVolumeToReservations < ActiveRecord::Migration
  def up
    add_column :reservations, :volume, :decimal, precision: 8, scale: 2
  end

  def down
    remove_column :reservations, :volume
  end
end
