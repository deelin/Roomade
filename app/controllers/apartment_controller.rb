class ApartmentController < ApplicationController
  def show
    @apartment = Apartment.find_by_id(params[:id])
    redirect_to home_path if @apartment.nil?
  end
  
  
end
