require 'cancan'
class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied, with: :new_login

  def new_login(e)
    redirect_to main_app.root_url, alert: e.message
  end
end
