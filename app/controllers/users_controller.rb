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
    respond_with(@user)
  end

  def update
    flash[:notice] = 'User was successfully updated.' if @user.update_attributes(params[:user])
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end
end
