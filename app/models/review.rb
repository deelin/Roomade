class Review < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :user
  
  # input validation
  validates :rent, :presence => true, :numericality => true
  validates :bedrooms, :presence => true, :numericality => {:only_integer => true}, :inclusion => { :in => 1..5 }
  validates :roommates, :presence => true, :numericality => {:only_integer => true}, :inclusion => { :in => 1..8 }
  validates :space, :presence => true, :numericality => {:only_integer => true}, :inclusion => { :in => 1..5 }
  validates :noise, :presence => true, :numericality => {:only_integer => true}, :inclusion => { :in => 1..5 }
  validates :management, :presence => true, :numericality => {:only_integer => true}, :inclusion => { :in => 1..5 }
  validates :condition, :presence => true, :numericality => {:only_integer => true}, :inclusion => { :in => 1..5 }
  validates :recommendation, :inclusion => { :in => [true, false] }
  validates :security, :inclusion => { :in => [true, false] }
  validates :description, :presence => true
  
  # uniqueness of review based on user and apartment
  validates_uniqueness_of :user_id, :scope => [:apartment_id], :message => "has already created a review for this apartment."
  
  def self.create_with_params(reviews_hash, user, apartment, rent_option, amenity_ids)
    return nil if apartment.nil? || rent_option.blank?
    # make sure option selectors have valid value
    return nil if !["yes", "no"].include?(reviews_hash[:recommendation]) || !["yes", "no"].include?(reviews_hash[:security]) || !["apartment", "per person"].include?(rent_option)
    # make sure amenity ids are valid
    amenity_ids.each do |id|
      return nil if id < 1 || id > 10
    end
    
    # update the review attributes based on parameters
    review = user.reviews.build(reviews_hash)
    review.apartment_id = apartment.id
    review.recommendation = (reviews_hash[:recommendation] == "yes" ? true : false)
    review.security = (reviews_hash[:security] == "yes" ? false : true)
    
    if rent_option != "apartment"
      # per person, so multiply by number of roommates
      price = reviews_hash[:rent].to_f * reviews_hash[:roommates].to_i
      review.rent = price
    end
    
    if review.save
      # valid review, create amenities by (noob) bulk insert. FIXME: find a better way to bulk insert
      ActiveRecord::Base.transaction do
        amenity_ids.each do |id|
          ApartmentAmenity.create(:apartment_id => apartment.id, :amenity_id => id)
        end
      end
      return review
    else
      logger.debug(review.errors.full_messages)
      return nil
    end
  end
end
