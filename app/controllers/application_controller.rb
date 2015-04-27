require 'cancan'
class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied, with: :new_login

  def new_login(e)
    redirect_to main_app.root_url, alert: e.message
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    '/admin'
  end
end
