class AddPhoneNumberToApartment < ActiveRecord::Migration
  def self.up
    add_column :apartments, :phone_number, :string
  end
  
  def self.down
    remove_column :apartments, :phone_number
  end
end
