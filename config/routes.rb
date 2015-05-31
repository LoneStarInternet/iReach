IReach::Application.routes.draw do
  devise_for :users
  
  scope path: :admin do
    resources :users
  end

    scope path: :admin do 
      resources :menu do
        collection do
          get :imp_exp
          get :renumber
        end
      end
      resources :admin_user
      resources :member do
        post :convention_ce_hours
        put :convention_ce_hours
      end
    end
    match '/admin/course_completions_report' => 'admin/course_completions_report#index', method: :get
    match '/admin/course_completions_report/members' => 'admin/course_completions_report#members', method: :get, as: :members_admin_course_completions_report
    match '/admin/conventions_report/:id' => 'admin/course_completions_report#conventions', method: :get, as: :admin_conventions_report
    match '/admin/member_search/search' => 'admin/member_search#search'
    match '/admin/member_search/results' => 'admin/member_search#results'
  
  
#    scope NewsletterPlugin::PATH_PREFIX.gsub(/^\//,''), :as => :newsletter do
#      resources :newsletters, module: 'newsletter' do
#        member do 
#          get :unpublish
#          get :publish
#        end
#        collection do
#          get :short
#        end
#        resources :pieces, :only => [:index,:new,:create]
#      end
#      resources :pieces, module: 'newsletter', :only => [:edit,:create,:update,:destroy]
#      resources :designs, module: 'newsletter' do
#        resources :elements, :only => [:index,:new,:create]
#      end
#      resources :elements, :only => [:edit,:create,:update,:destroy], module: 'newsletter'
#    end
#    match "#{NewsletterPlugin::PATH_PREFIX}/newsletters/:newsletter_id/areas/:id/sort" => "newsletter/areas#sort", :method => :get, as: 'sort_newsletter_newsletter_area'
#  
#  
#    begin
#      mail_mgr_path_prefix = "#{Conf.site_path}#{Conf.mail_mgr_path_prefix}"
#      unsubscribe_path = "#{Conf.site_path}#{Conf.mail_mgr_unsubscribe_path}"
#    rescue => e
#      mail_mgr_path_prefix = '/admin/mail_mgr'
#      unsubscribe_path = '/listmgr'
#    end
#  
#    match "#{unsubscribe_path}/:guid", :controller => 'mail_mgr/subscriptions', 
#      :action => 'unsubscribe'
#  
#    scope MailMgrPlugin::PATH_PREFIX.gsub(/^\//,''), :as => :mail_mgr do
#      resources :mailings, module: 'mail_mgr' do
#        member do
#          post :send_test
#          get :test
#          get :schedule
#          get :pause
#          get :cancel
#        end
#        resources :messages, only: [:index]
#      end
#  
#      resources :bounces, only: [:index, :show], module: 'mail_mgr' do
#        member do
#          get :dismiss
#          get :fail_address
#        end
#      end
#
#      resources :mailing_lists, module: 'mail_mgr' do
#        resources :subscriptions, only: [:index,:new]
#      end
#  
#      match '/unsubscribe_by_email_address' => 'mail_mgr/subscriptions#unsubscribe_by_email_address'
#      resources :contacts, :module => 'mail_mgr' do
#        member do
#          get :send_one_off_message
#        end
#      end
#    end
#    # After the default route is searched, if we found nothing, lets check for an admin call and force it to go to admin/home instead of failing
#    match '/admin' => 'admin/home#index'

  mount IReach::Engine => "/admin", layout: 'application'

  root to: 'admin/home#index'

  get '/admin', to: 'admin/home#index'

  get '/status', to: 'status#index'

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
