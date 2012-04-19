class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  
  def create
    logger.debug("in action create")
    build_resource
    # resource.email = session[:omniauth]['info']['email'] if session[:omniauth].present?
    
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end

    session[:omniauth] = nil unless @user.new_record?
  end
  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      logger.debug("this was called")
      @user.apply_omniauth(session[:omniauth])
      @user.email = session[:omniauth]['info']['email']
      @user.valid?
    end
  end
end
