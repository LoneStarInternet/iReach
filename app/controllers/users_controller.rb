class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  def index
    @users = User.paginate(page: (params[:page] || 1))
    respond_with(@users)
  end

  def show
    respond_with(@user)
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def edit
  end

  def create
    @user = User.new(params[:user])
    flash[:notice] = 'User was successfully created.' if @user.save
    respond_with(@user, location: (current_user.admin? ? users_path : '/admin'))
  end

  def update
    if params[:user].try(:has_key?,:password)
      unless params[:user][:password].present? || params[:user][:password_confirmation].present? || !current_user.is_admin? || !current_user == @user
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end
    if !current_user.is_admin? && params[:user].try(:has_key?,:roles).present?
      params[:user].delete(:roles)
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.' 
      sign_in(@user, :bypass => true) if @user == current_user
    end
    respond_with(@user, location: (current_user.admin? ? users_path : '/admin'))
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end
end
