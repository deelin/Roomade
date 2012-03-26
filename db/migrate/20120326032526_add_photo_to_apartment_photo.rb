class AddPhotoToApartmentPhoto < ActiveRecord::Migration
  def self.up
    change_table :apartment_photos do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :apartment_photos, :photo
  end
end
