class ReviewController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @reviews = Review.all
  end
  
  def create
    @apartment = Apartment.find_or_create_by_address(params[:formatted_address])
    @review = Review.create(params[:review])
    @review.apartment_id = @apartment.id
    if @review.save
      flash[:notice] = "Review created!"
      redirect_to home_path and return
    else
      flash[:error] = "Failed to create view."
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
