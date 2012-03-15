class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def redirect_if_logged_in
    # this gets called when a user tries to access any methods in the PublicController
    redirect_to home_path if current_user.present?
  end
      
  private
    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
  
    def after_sign_in_path_for(resource_or_scope)
      home_path
    end
end
