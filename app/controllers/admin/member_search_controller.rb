class Admin::MemberSearchController < ApplicationController
   
  authorize_resource class: false 

  layout 'admin'

  def index
   redirect_to :action => 'search'
  end

  def search
  end

  def results

    conditionstr = []
    conditions = []

    if !params[:member_search].nil?

       # if !params[:member_search][:first_name].nil? # and !params[:member_search][:first_name].blank?
       if !params[:member_search][:first_name].nil? 
         conditionstr << "members.first_name like ?"
         conditions << '%' + params[:member_search][:first_name] + '%'
       end

       if !params[:member_search][:last_name].nil? and !params[:member_search][:last_name].blank?
         conditionstr << "members.last_name like ?"
         conditions << '%' + params[:member_search][:last_name] + '%'
       end
       
       if !params[:member_search][:mailing_address].nil? and !params[:member_search][:mailing_address].blank?
         conditionstr << "members.mailing_address like ?"
         conditions << '%' + params[:member_search][:mailing_address] + '%'
       end
       
       if !params[:member_search][:mailing_city].nil? and !params[:member_search][:mailing_city].blank?
         conditionstr << "members.mailing_city like ?"
         conditions << '%' + params[:member_search][:mailing_city] + '%'
       end
       
       if !params[:member_search][:mailing_state].nil? and !params[:member_search][:mailing_state].blank?
         conditionstr << "members.mailing_state like ?"
         conditions << '%' + params[:member_search][:mailing_state] + '%'
       end
       
       if !params[:member_search][:mailing_zip].nil? and !params[:member_search][:mailing_address].blank?
         conditionstr << "members.mailing_zip like ?"
         conditions << '%' + params[:member_search][:mailing_zip] + '%'
       end
       
       if !params[:member_search][:email].nil? and !params[:member_search][:email].blank?
         conditionstr << "members.email like ?"
         conditions << '%' + params[:member_search][:email] + '%'
       end
       
       if !params[:member_search][:membership_type_id].nil? and !params[:member_search][:membership_type_id].blank?
         conditionstr << "members.membership_type_id like ?"
         conditions << '%' + params[:member_search][:membership_type_id] + '%'
       end

       if !params[:member_search][:business_address].nil? and !params[:member_search][:business_address].blank?
         conditionstr << "members.business_address like ?"
         conditions << '%' + params[:member_search][:business_address] + '%'
       end
       
       if !params[:member_search][:business_city].nil? and !params[:member_search][:business_city].blank?
         conditionstr << "members.business_city like ?"
         conditions << '%' + params[:member_search][:business_city] + '%'
       end
       
       if !params[:member_search][:business_state].nil? and !params[:member_search][:business_state].blank?
         conditionstr << "members.business_state like ?"
         conditions << '%' + params[:member_search][:business_state] + '%'
       end
       
       if !params[:member_search][:business_zip].nil? and !params[:member_search][:business_zip].blank?
         conditionstr << "members.business_zip like ?"
         conditions << '%' + params[:member_search][:business_zip] + '%'
       end
      
    end

    if conditionstr.length == 0

       logger.error( "dammit, no conditions! ")

      conditions = session[:member_search_conditions] if !session[:member_search_conditions].nil?
    else
      conditions.unshift(conditionstr.join(" and "))
    end

    if conditions.length > 0
      #Save search params into session in case we come back later, so we don't have to pass
      #all these params all over the place.
      
      session[:member_search_conditions] = conditions
      @results = Member.paginate( :page => params[:page],
                                  :per_page => 100,
                                  :include => [:membership_type],
                                  :conditions => conditions,
                                  :order => "last_name, first_name" )
    else
      @results = Member.paginate( :page => params[:page],
                                  :per_page => 100,
                                  :include => [:membership_type],
                                  :order => "last_name, first_name" )
    end
   end

end
