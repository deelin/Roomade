class RegistrationsController < Devise::RegistrationsController
  def new
    resource = build_resource
    
    respond_with_navigational(resource){ render :new }
  end
  
  def create
    build_resource
    
    if resource.save      
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      # redirect_to new_user_signup_path and return
      respond_with_navigational(resource) { render :new }
    end  
    
  end
end
