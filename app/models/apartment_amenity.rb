class ApartmentAmenity < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :amenity
  
end
