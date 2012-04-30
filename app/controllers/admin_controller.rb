class AdminController < ApplicationController
  before_filter :check_admin
  
  def index
    @apartments = Apartment.find(:all, :include => [:apartment_photos, :reviews])
    @users = User.find(:all, :include => [:authentications, :reviews])
    @reviews = Review.find(:all, :include => [:user, :apartment])
    
  end
end
