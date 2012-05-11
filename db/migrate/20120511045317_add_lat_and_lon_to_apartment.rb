class AddLatAndLonToApartment < ActiveRecord::Migration
  def self.up
    add_column :apartments, :latitude, :float
    add_column :apartments, :longitude, :float
  end
  
  def self.down
    remove_column :apartments, :latitude
    remove_column :apartments, :longitude
  end
end
