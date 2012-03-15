class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :apartment_id
      t.float :rent
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :roommates
      t.integer :space
      t.integer :noise
      t.boolean :security
      t.integer :management
      t.integer :condition
      t.boolean :recommendation
      t.text :description

      t.timestamps
    end
  end
end
