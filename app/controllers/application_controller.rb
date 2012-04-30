class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  
  def redirect_if_logged_in
    # this gets called when a user tries to access any methods in the PublicController
    redirect_to root_path and return if current_user.present?
  end
  
  def redirect_back_or(path = root_path)
    redirect_to :back and return
  rescue ActionController::RedirectBackError
    redirect_to path and return
  end
  
  def check_admin
    redirect_to root_path and return unless current_user.present? && current_user.id == 1
  end
      
  private
    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
  
    def after_sign_in_path_for(resource)
      stored_location_for(resource) || root_path
    end

    
    
end
