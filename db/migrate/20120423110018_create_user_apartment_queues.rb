class CreateUserApartmentQueues < ActiveRecord::Migration
  def change
    create_table :user_apartment_queues do |t|
      t.integer :user_id
      t.integer :apartment_id

      t.timestamps
    end
  end
end
