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
end
