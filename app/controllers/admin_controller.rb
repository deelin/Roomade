class AdminController < ApplicationController
  before_filter :check_admin
  
  def index
    @apartments = Apartment.find(:all, :include => [:apartment_photos, :reviews], :order => "id asc")
    @users = User.find(:all, :include => [:authentications, :reviews], :order => "id asc")
    @reviews = Review.find(:all, :include => [:user, :apartment], :order => "id asc")
    
  end
end
