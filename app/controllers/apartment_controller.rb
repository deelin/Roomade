class ApartmentController < ApplicationController
  def show
    @apartment = Apartment.find_by_id(params[:id])
    redirect_to home_path if @apartment.nil?
    @reviews = @apartment.reviews
    ratings_hash = Hash.new(0)
    
    @reviews.each do |review|
      ratings_hash["noise"] += review.noise
      ratings_hash["condition"] += review.condition
      # ratings_hash["security"] += review.security
      ratings_hash["management"] += review.management
    end
    ratings_hash.each do |key, value|
      ratings_hash[key] = value/@reviews.length
    end
    
  end
  
  
end
