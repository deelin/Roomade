class CreateApartmentPhotos < ActiveRecord::Migration
  def change
    create_table :apartment_photos do |t|
      t.integer :address_id

      t.timestamps
    end
  end
end
