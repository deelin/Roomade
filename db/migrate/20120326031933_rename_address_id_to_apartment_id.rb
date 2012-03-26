class RenameAddressIdToApartmentId < ActiveRecord::Migration
  def self.up
    rename_column :apartment_photos, :address_id, :apartment_id
  end

  def self.down
    rename_column :apartment_photos, :apartment_id, :address_id
  end
end
