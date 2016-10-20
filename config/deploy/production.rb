set :application, "thaa.lnstar.com"
set :deploy_to, "/var/www/#{application}"
set :domain, "rails.lnstar.com"
set :user, "deploy"
set :web_user, 'wwwrails'
set :rails_env, "production"
set :branch, application
set :unicorn_pid, "/var/www/#{application}/shared/tmp/pids/unicorn.pid"
