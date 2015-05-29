class Admin::MemberController < ApplicationController

  #before_filter :admin_authenticate

  layout 'admin'

  def index
    list
    render :action => 'list'
  end

  def convention_ce_hours
    member = Member.find(params[:member_id])
    year = params[:year]
    member.send("convention_#{year}_ce_hours=",params[:member]["convention_#{year}_ce_hours"])
    respond_to do |format|
      format.json { respond_with_bip(member) }
    end
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => :post, :only => [ :destroy, :create, :update ],
  #        :redirect_to => { :action => :list }

  def list
    @member_pages, @members = paginate :members, :per_page => 10
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
  end

  def create
    params[:member][:password_confirmation] = params[:member][:password]
    @member = Member.new(params[:member])
    if @member.save
      flash[:notice] = 'Member was successfully created.'
      redirect_to edit_admin_member_path(@member)
    else
      render :action => 'new'
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    params[:member][:password_confirmation] = params[:member][:password]
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member])
      flash[:notice] = 'Member was successfully updated.'
      redirect_to :action => 'results', :controller => 'member_search'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Member.find(params[:id]).destroy
    flash[:notice] = 'Member successfully deleted'
    redirect_to :action => 'search', :controller => 'member_search'
  end

end
