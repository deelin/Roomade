class AddSecurityLevelToReview < ActiveRecord::Migration
  def self.up
    add_column :reviews, :security_level, :integer
  end
  
  def self.down
    remove_column :reviews, :security_level
  end
end
