require 'cancan'
class ApplicationController < ActionController::Base
  protect_from_forgery
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied, with: :new_login

  def new_login(e)
    redirect_to '/admin', alert: e.message
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    path = if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
    if path !~ %r#/admin#
      '/admin'
    else
      path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    '/admin'
  end
end
