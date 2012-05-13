class ReviewController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  
  def index
    @reviews = Review.all
  end
  
  def create
    apartment = Apartment.find_or_create_by_address(params[:formatted_address].gsub("Street", "St"))
    if apartment.dist_to_campus.nil?
      if params[:dist_to_campus].to_f.to_s != params[:dist_to_campus] || params[:latitude].to_f.to_s != params[:latitude] || params[:longitude].to_f.to_s != params[:longitude]
        flash[:error] = "Failed to create review."
        redirect_to new_review_path and return
      else
        apartment.dist_to_campus = params[:dist_to_campus].to_f.round(1)
        apartment.latitude = params[:latitude].to_f
        apartment.longitude = params[:longitude].to_f
        apartment.save
      end
    end
    
    amenity_ids = params[:amenities].split(",").uniq.map{|id| id.to_i}
    @review = Review.create_with_params(params[:review], current_user, apartment, params[:rent_option], amenity_ids, params[:photo])
    
    if @review.present?
      flash[:notice] = "Review created!"
      redirect_to show_apartment_path(:id => apartment.id) and return
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
