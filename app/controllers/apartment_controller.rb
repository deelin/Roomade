class ApartmentController < ApplicationController
  def show
    @apartment = Apartment.find_by_id(params[:id])
    redirect_to home_path and return if @apartment.blank?
    
    @reviews = @apartment.reviews
    @amenities = @apartment.amenities.map(&:id)
    
    @recommendations = @reviews.count(:all, :conditions => {:recommendation => true})
    @ratings_hash = @apartment.get_ratings_hash
    @price_range_hash = @apartment.get_price_range
    @address_hash = @apartment.get_address_hash
    @apartment_photos = @apartment.get_photos
  end
  
  
end
