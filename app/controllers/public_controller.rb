class PublicController < ApplicationController
  before_filter :redirect_if_logged_in
  def index
  end
end
