class AddFieldsToAdverts < ActiveRecord::Migration
  def up
    add_column :adverts, :security, :integer
    add_column :adverts, :preservation, :integer
    add_column :adverts, :floor, :integer
    add_column :adverts, :complete, :boolean, default: false
    add_column :adverts, :from_date, :date
    remove_column :adverts, :city
  end

  def down
    remove_column :adverts, :security
    remove_column :adverts, :preservation
    remove_column :adverts, :floor
    remove_column :adverts, :complete
    remove_column :adverts, :from_date
    add_column :adverts, :city, :string
  end
end
