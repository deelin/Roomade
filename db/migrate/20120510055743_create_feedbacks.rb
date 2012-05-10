class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.boolean :recommendation
      t.text :comment

      t.timestamps
    end
  end
end
