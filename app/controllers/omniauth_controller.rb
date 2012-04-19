class OmniauthController < ApplicationController
  layout nil
  
  def create
    omniauth = request.env["omniauth.auth"]
    logger.debug(omniauth['info'])
    session[:auth_provider] = omniauth['provider']
    session[:auth_uid] = omniauth['uid']
    session[:auth_name] = omniauth['info']['name']
    session[:auth_handle] = omniauth['info']['nickname']
    session[:auth_email] = omniauth['info']['email']
    session[:auth_token] = omniauth['credentials']['token']
    session[:auth_secret] = omniauth['credentials']['secret']
    session[:redirect_once] = true
    render :reload_parent
  end
  
  def unlink
    redirect_to settings_path and return if !["facebook", "twitter"].include?(params[:provider])
    @provider = params[:provider]
    auth = current_user.auths.find_by_provider(@provider)
    if auth.nil?
      flash[:alert] = "#{@provider.capitalize} was not connected"
    else
      auth.destroy
      flash[:notice] = "#{@provider.capitalize} disconnected"
    end
    redirect_to settings_path
  end
  
  def reload_parent
    @retry = true
  end
  
  def failure
    if session[:auth_provider] == "twitter"
      redirect_to (session[:auth_redirect].present? ? session[:auth_redirect] : root_path) and return
    end
  end
  
  def passthru
    session[:auth_provider] = params[:provider]
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end
end