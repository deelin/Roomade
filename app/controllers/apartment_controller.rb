class ApartmentController < ApplicationController
  def show
    @apartment = Apartment.find_by_id(params[:id])
    redirect_to home_path if @apartment.nil?
    
    @reviews = @apartment.reviews
    @recommendations = @reviews.count(:all, :conditions => {:recommendation => true})
    @ratings_hash = @apartment.get_ratings_hash
    @price_range_hash = @apartment.get_price_range
    @address_hash = @apartment.get_address_hash
    
  end
  
  
end
