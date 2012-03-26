class Apartment < ActiveRecord::Base
  has_many :reviews
  has_many :apartment_amenities, :foreign_key => "apartment_id"
  has_many :amenities, :through => :apartment_amenities, :source => :amenity
  has_many :apartment_photos, :order => "created_at desc"
  
  def get_ratings_hash
    reviews = self.reviews
    return {} if reviews.blank?
    
    ratings_hash = Hash.new(0)
    
    reviews.each do |review|
      ratings_hash["noise"] += review.noise
      ratings_hash["condition"] += review.condition
      ratings_hash["security_level"] += review.security_level
      ratings_hash["management"] += review.management
    end
    
    # normalize
    ratings_hash.each do |key, value|
      ratings_hash[key] = value/reviews.length
    end
    
    return ratings_hash
  end
  
  def get_price_range
    min = self.reviews.minimum(:rent)
    max = self.reviews.maximum(:rent)
    price_range_hash = Hash.new
    price_range_hash["min"] = min
    price_range_hash["max"] = max
    return price_range_hash
  end
  
  def get_address_hash
    parsed_address = self.address.split(",")
    address_hash = Hash.new
    address_hash["street"] = parsed_address[0]
    address_hash["city"] = parsed_address[1].strip + "," + parsed_address[2]
    return address_hash
  end
  
  def get_photos
    return self.apartment_photos
  end
end
