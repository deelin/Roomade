class ReviewController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  
  def index
    @reviews = Review.all
  end
  
  def create
    apartment = Apartment.find_or_create_by_address(params[:formatted_address])
    amenity_ids = params[:amenities].split(",").uniq.map{|id| id.to_i}
    @review = Review.create_with_params(params[:review], current_user, apartment, params[:rent_option], amenity_ids)
    
    if @review.present?
      flash[:notice] = "Review created!"
      redirect_to home_path and return
    else
      flash[:error] = "Failed to create review."
      redirect_to new_review_path and return
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def new
    @review = Review.new
  end
  
end