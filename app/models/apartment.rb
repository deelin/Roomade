class Apartment < ActiveRecord::Base
  has_many :reviews, :include => :user
  has_many :apartment_amenities, :foreign_key => "apartment_id"
  has_many :amenities, :through => :apartment_amenities, :source => :amenity
  has_many :apartment_photos, :order => "created_at desc"
  has_many :user_apartment_queues
  
  self.per_page = 2
  accepts_nested_attributes_for :apartment_photos, :allow_destroy => true
  
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
    return self.apartment_photos.where("photo_file_name is NOT NULL")
  end
  
  def self.search(query, filter_hash, sort, amenities, page)
    logger.debug(query)
    # return [] if query.blank? 
    # determine query
    query_cond = ""
    terms = query.gsub(" street", " st").gsub(" california", " ca").gsub(",", " ").split(" ")
    terms.each do |term|
      query_cond += " upper(address) like upper('%#{term}%') and"
    end
    logger.debug(query_cond)
    
    page = (page.to_i == 0 ? 1 : page.to_i)
    # determine bedroom range
    min_bedrooms = filter_hash[:bedrooms][:min].to_i
    max_bedrooms = filter_hash[:bedrooms][:max].to_i
    min_bedrooms = 1 unless (1..5).include?(min_bedrooms)
    max_bedrooms = 5 unless ((1..5).include?(max_bedrooms) && max_bedrooms >= min_bedrooms)
    # determine bathroom range
    min_bathrooms = filter_hash[:bathrooms][:min].to_i
    max_bathrooms = filter_hash[:bathrooms][:max].to_i
    min_bathrooms = 1 unless (1..5).include?(min_bathrooms)
    max_bathrooms = 5 unless ((1..5).include?(max_bathrooms) && max_bathrooms >= min_bathrooms)
    # determine apartment mates range
    min_roommates = filter_hash[:roommates][:min].to_i
    max_roommates = filter_hash[:roommates][:max].to_i
    min_roommates = 1 unless (1..7).include?(min_roommates)
    max_roommates = 5 unless ((1..7).include?(max_roommates) && max_roommates >= min_roommates)
    # determine price range
    min_price = filter_hash[:rent][:min].to_i
    max_price = filter_hash[:rent][:max].to_i
    min_price = 0 if min_price.blank? || !([0, 200, 600, 1000].include?(min_price.to_i))
    max_price = 9999 if max_price.blank? || !([200, 600, 1000, 1500].include?(max_price.to_i))
    # determine amenities
    if amenities.present?
      amenity_ids = amenities.split(",").map{|str| str.to_i}
      amenity_ids.keep_if {|amenity_id| amenity_id >= 1 && amenity_id <= 10}
      joined_amenities = amenity_ids.join(",")
    else
      amenity_ids = []
      joined_amenities = "0"
    end
        
    # determine sort
    if sort.present?    
      sort_hash = {"rent" => "avg_rent", 
        "distance" => "apartments.dist_to_campus",
        "rating" => "avg_rating",
        "noise" => "avg_noise",
        "condition" => "avg_condition",
        "security" => "avg_security_level",
        "management" => "avg_management"}
      parsed_sort = sort.split("_")
      sort_key = parsed_sort[0]      
      sort_type = (sort_hash.has_key?(sort_key) ? sort_hash[sort_key] : "reviews.rent")
      sort_order = (["asc", "desc"].include?(parsed_sort[1]) ? parsed_sort[1] : "desc") # default to desc
    end
    
    # query with conds
    ApartmentAmenity.select("*, sum(case when amenity_id in (1, 2, 3, 4, 5, 6) then 1 else 0 end) as amenities_count").group("apartment_id").having("amenities_count = 6")
    
    if Rails.env.production? 
      join_cond = "inner join reviews on (reviews.apartment_id = apartments.id) inner join apartment_amenities on (apartment_amenities.apartment_id = apartments.id)"
    elsif Rails.env.development?
      join_cond = "inner join reviews on reviews.apartment_id = apartments.id, apartment_amenities on apartment_amenities.apartment_id = apartments.id"
    end
    results = Apartment.paginate(:select => "apartments.*, (select avg(rent) from reviews where reviews.apartment_id = apartments.id) as avg_rent, (select avg(bedrooms) from reviews where reviews.apartment_id = apartments.id) as avg_bedrooms, (select avg(bathrooms) from reviews where reviews.apartment_id = apartments.id) as avg_bathrooms, (select avg(roommates) from reviews where reviews.apartment_id = apartments.id) as avg_roommates, (select avg(rent) from reviews where reviews.apartment_id = apartments.id) as avg_rent, (select avg(rating) from reviews where reviews.apartment_id = apartments.id) as avg_rating, (select avg(noise) from reviews where reviews.apartment_id = apartments.id) as avg_noise, (select avg(condition) from reviews where reviews.apartment_id = apartments.id) as avg_condition, (select avg(security_level) from reviews where reviews.apartment_id = apartments.id) as avg_security_level, (select avg(management) from reviews where reviews.apartment_id = apartments.id) as avg_management, sum(case when apartment_amenities.amenity_id in (#{joined_amenities}) then 1 else 0 end) as matched_amenities_count", :conditions => ["#{query_cond} (select avg(rent) from reviews where reviews.apartment_id = apartments.id) > ? and (select avg(rent) from reviews where reviews.apartment_id = apartments.id) <= ? and (select avg(bedrooms) from reviews where reviews.apartment_id = apartments.id) >= ? and (select avg(bedrooms) from reviews where reviews.apartment_id = apartments.id) <= ? and (select avg(bathrooms) from reviews where reviews.apartment_id = apartments.id) >= ? and (select avg(bathrooms) from reviews where reviews.apartment_id = apartments.id) <= ? and (select avg(roommates) from reviews where reviews.apartment_id = apartments.id) >= ? and (select avg(roommates) from reviews where reviews.apartment_id = apartments.id) <= ?", min_price, max_price, min_bedrooms, max_bedrooms, min_bathrooms, max_bathrooms, min_roommates, max_roommates], :joins => join_cond, :include => [:reviews, :apartment_amenities, :apartment_photos], :order => "#{sort_type} #{sort_order}", :group => "apartments.id, apartments.address, apartments.name, apartments.created_at, apartments.updated_at, apartments.phone_number, apartments.dist_to_campus, apartment_amenities.apartment_id", :having => "sum(case when apartment_amenities.amenity_id in (#{joined_amenities}) then 1 else 0 end) = #{amenity_ids.length}", :page => page).uniq.group_by { |apartment| apartment.id }
    logger.debug(page)
    logger.debug(results)
    return results
  end
  
  def merge(apartment)
    return false if self.nil? || apartment.nil? || self.id == apartment.id
    reviews = self.reviews
    reviews.each do |review|
      review.apartment_id = apartment.id
      review.save
    end
    self.destroy
  end
    
end
