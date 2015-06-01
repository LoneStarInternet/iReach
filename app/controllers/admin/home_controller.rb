class Admin::HomeController < ApplicationController
   authorize_resource class: false

   def index
      #redirect_to( :action => 'search', :controller => 'member_search' )
   end

end
