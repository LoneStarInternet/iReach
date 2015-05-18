set :application, "news.lone-star.net"
set :deploy_to, "/home/httpd/#{application}"
set :domain, "zoidberg.lnstar.com"
set :user, "deploy"
set :web_user, 'wwwrails'
set :rails_env, "production"
set :branch, application
set :unicorn_pid, "/home/httpd/#{application}/shared/tmp/pids/unicorn.pid"
