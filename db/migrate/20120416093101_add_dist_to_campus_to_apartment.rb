class AddDistToCampusToApartment < ActiveRecord::Migration
  def self.up
    add_column :apartments, :dist_to_campus, :float
  end
  
  def self.down
    remove_column :apartments, :dist_to_campus
  end
end
