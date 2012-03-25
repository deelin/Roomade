class ApartmentAmenity < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :amenity
  validates_uniqueness_of :apartment_id, :scope => [:amenity_id]

end
