class Apartment < ActiveRecord::Base
  has_many :reviews
  has_many :amenities
end
