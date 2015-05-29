class Admin::HomeController < ApplicationController

   #before_filter :admin_authenticate
   layout 'admin'

   def index
      #redirect_to( :action => 'search', :controller => 'member_search' )
   end

end
