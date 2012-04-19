class AuthenticationController < ApplicationController
  
  def index
    @authentications = current_user.authentications
  end
  
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Successfully created authentication."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to home_path and return
    else
      user = User.new
      user.apply_omniauth(omniauth)
      user.email = omniauth["info"]["email"]
      if user.save
        flash[:notice] = "Successfully created authentication."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_path and return
      end
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    if current_user.password.blank?
      flash[:error] = "You must set a password before you can unlink your Facebook account"
      redirect_to home_path and return
    end
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication"
    redirect_to home_path and return
  end
  
  protected

  # This is necessary since Rails 3.0.4
  # See https://github.com/intridea/omniauth/issues/185
  # and http://www.arailsdemo.com/posts/44
  def handle_unverified_request
    true
  end
end