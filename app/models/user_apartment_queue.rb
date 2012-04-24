class UserApartmentQueue < ActiveRecord::Base
  belongs_to :user
  belongs_to :apartment
  
  validates_uniqueness_of :user_id, :scope => [:apartment_id]

end
