class AdminController < ApplicationController
  before_filter :check_admin
  
  def index    
    if request.xhr?
      @table = params[:table]
      col = (params[:col].blank? ? "id" : params[:col])
      order = params[:order]
      order_cond = "#{col} #{order}"
      if @table == "apartments"
        @apartments = Apartment.find(:all, :include => [:apartment_photos, :reviews], :order => order_cond)
      elsif @table == "users"
        @users = User.find(:all, :include => [:authentications, :reviews], :order => order_cond)
      elsif @table == "reviews"
        @reviews = Review.find(:all, :include => [:user, :apartment], :order => order_cond)
      end
    else
      @apartments = Apartment.find(:all, :include => [:apartment_photos, :reviews], :order => "id asc")
      @users = User.find(:all, :include => [:authentications, :reviews], :order => "id asc")
      @reviews = Review.find(:all, :include => [:user, :apartment], :order => "id asc")
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
    render :nothing => true and return if @apartment_one.nil? || @apartment_two.nil?
    if @apartment_one.merge(@apartment_two)
      @message = "Successfully merged reviews from apartments!"
      @success = true
    else
      @message = "Could not merge apartments"
    end
  end
end
