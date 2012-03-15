class CreateApartmentAmenities < ActiveRecord::Migration
  def change
    create_table :apartment_amenities do |t|
      t.integer :apartment_id
      t.integer :amenity_id

      t.timestamps
    end
  end
end
