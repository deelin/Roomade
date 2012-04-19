class UserController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  
  def show
    # if params[:shortname].present?
    #   @user = User.find(:first, :conditions => ["lower(username) = lower(?)", params[:shortname]])
    # else
    #   @user = User.find_by_id(params[:id])
    #   redirect_to home_path and return if @user.nil?
    #   redirect_to users_show_path(:shortname => @user.username) and return
    # end
  end
  
  def edit
    
  end
  
  def update
    current_user.photo = params[:user][:photo]
    if current_user.save
      flash[:message] = "Photo changed!"
    else
      flash[:error] = "Photo is invalid"
    end
    redirect_to home_path and return
  end
  
end
