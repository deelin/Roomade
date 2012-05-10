class AdminController < ApplicationController
  before_filter :check_admin
  
  def index    
    if request.xhr?
      @table = params[:table]
      col = (params[:col].blank? ? "id" : params[:col])
      order = params[:order]
      order_cond = "#{col} #{order}"
      if @table == "apartments"
        if col == "num_reviews"
          @apartments = Apartment.joins("left outer join reviews on reviews.apartment_id = apartments.id").select("apartments.*, (select count(*) from reviews where reviews.apartment_id = apartments.id) as reviews_count").includes([:apartment_photos, :reviews]).order("reviews_count #{order}").group("apartments.id, apartments.address, apartments.name, apartments.created_at, apartments.updated_at, apartments.phone_number, apartments.dist_to_campus")
        elsif col == "num_photos"
          @apartments = Apartment.joins("left outer join apartment_photos on apartment_photos.apartment_id = apartments.id").select("apartments.*, (select count(*) from apartment_photos where apartment_photos.apartment_id = apartments.id) as apartment_photos_count").includes([:apartment_photos, :reviews]).order("apartment_photos_count #{order}").group("apartments.id, apartments.address, apartments.name, apartments.created_at, apartments.updated_at, apartments.phone_number, apartments.dist_to_campus")
        else
          @apartments = Apartment.find(:all, :include => [:apartment_photos, :reviews], :order => order_cond)
        end
      elsif @table == "users"
        @users = User.find(:all, :include => [:authentications, :reviews], :order => order_cond)
      elsif @table == "reviews"
        @reviews = Review.find(:all, :include => [:user, :apartment], :order => order_cond)
      end
    else
      @apartments = Apartment.find(:all, :include => [:apartment_photos, :reviews], :order => "id asc")
      @users = User.find(:all, :include => [:authentications, :reviews], :order => "id asc")
      @reviews = Review.find(:all, :include => [:user, :apartment], :order => "id asc")
      @feedbacks = Feedback.find(:all, :order => "id asc")
    end
    
      
  end
  
  def destroy_apartment
    @apartment = Apartment.find_by_id(params[:id])
    if @apartment.nil?
      redirect_to "index" and return
      @message = "That apartment does not exist"
    else
      @apartment.destroy
      @success = true
      @message = "Apartment record deleted!"
    end
  end
  
  def merge_apartments
    @apartment_one = Apartment.find_by_id(params[:apartment_one_id])
    @apartment_two = Apartment.find_by_id(params[:apartment_two_id])
    if @apartment_one.merge(@apartment_two)
      @message = "Successfully merged reviews!"
      @num_reviews = @apartment_two.reviews.size
      @success = true
    else
      @message = "Could not merge apartments"
    end
  end
end
