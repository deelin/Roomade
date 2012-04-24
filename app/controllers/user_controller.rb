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
  
  def enqueue
    if request.xhr?
      @apartment = Apartment.find_by_id(params[:apartment_id])
      if @apartment.nil?
        @message = "Apartment does not exist."
      else
        enqueued_apt = current_user.user_apartment_queues.build(:apartment_id => @apartment.id)
        if enqueued_apt.save
          @message = "Successfully added this apartment to your queue"
          @success = true
        else
          @message = "This apartment is already in your queue"
        end
      end
    else
      redirect_to :back and return
    end
  end
  
  def dequeue
    if request.xhr?
      @apartment = Apartment.find_by_id(params[:apartment_id])
      if @apartment.nil?
        @message = "Apartment does not exist."
      else
        dequeued_apt = current_user.user_apartment_queues.find_by_apartment_id(@apartment.id)
        if dequeued_apt.nil?
          @message = "This apartment was not in your queue"
        else
          dequeued_apt.destroy
          @message = "Successfully removed this apartment from your queue"
          @success = true
        end
      end
    else
      redirect_to :back and return
    end
  end
  
  def queue
    # may sort/filter later
    @enqueued_apartments = current_user.user_apartment_queues.includes([:review, :apartment_amenities])
    
  end
  
end
