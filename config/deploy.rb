set :application, ""
set :keep_releases, 2

# RVM bootstrap
require 'rvm/capistrano'
set :rvm_ruby_string, '2.1.5'
set :rvm_type, :system

# hipchat integration
require 'hipchat/capistrano'
set :hipchat_token, "b3a4ba9ee30453a2f9a51ba8d84b79"
set :hipchat_room_name, "Lone Star Internet"
set :hipchat_announce, false # notify users?


# bundler bootstrap
require 'bundler/capistrano'

set :stages, %w(production staging)
set :default_stage, "production"
require 'capistrano/ext/multistage'

require 'capistrano-unicorn'

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = %w('~/.ssh/id_rsa.pub')
set :deploy_to, "/home/httpd/#{application}"
set :deploy_via, :remote_cache
set :user, "deploy"
set :use_sudo, false
set :normalize_asset_timestamps, false

# repo details
set :scm, :git
#set :scm_username, "nobody"
set :repository,  "ssh://git@bender.lnstar.com/var/git/iReachDeployments.git"
set :git_enable_submodules, 1


# def rake(cmd='', options={}, &block)
#   command = "cd #{current_release} && /usr/bin/env bundle exec rake #{cmd} RAILS_ENV=#{rails_env}"
#   run(command, options, &block)
# end

# this is useful in a shared hosting environment, where you have your own JAVA_HOME or GEM_HOME.
# otherwise, just set RAILS_ENV
set(:rake) { "RAILS_ENV=#{rails_env} bundle exec rake" }

# since :domain is defined in another file (staging.rb and production.rb),
# we need to delay its assignment until they're loaded
set(:domain) { "#{domain}" }
role(:web) { domain }
role(:app) { domain }
role(:db, :primary => true) { domain }

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:finalize", "deploy:cleanup"

#after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)

namespace :deploy do
  desc "Start Application"
  task :start, :roles => :app do
    `ssh #{web_user}@#{domain} "/etc/init.d/unicorn start #{application} && cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job start -p#{application}"`
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && bundle exec whenever --set 'environment=#{rails_env}' --update-crontab #{application}"
  end

  desc "Stop Application"
  task :stop, :roles => :app do
    `ssh #{web_user}@#{domain} "/etc/init.d/unicorn stop #{application} && cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job stop"`
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    `ssh #{web_user}@#{domain} "/etc/init.d/unicorn graceful #{application} && cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job restart"`
  end

  namespace :delayed_job do
    desc "Restart Delayed Job"
    task :restart, :roles => :app do
      `ssh #{web_user}@#{domain} "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job restart"`
    end
  
    desc "Stop Delayed Job"
    task :stop, :roles => :app do
      `ssh #{web_user}@#{domain} "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job stop"`
    end

    desc "Start Delayed Job"
    task :start, :roles => :app do
      `ssh #{web_user}@#{domain} "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job start -p#{application}"`
    end
  end

  desc "Precompile Assets"
  task :precompile_assets, :roles => :app do
    #run "source /usr/local/rvm/scripts/rvm && cd #{release_path} && RAILS_GROUPS=assets RAILS_ENV=#{rails_env } bundle exec rake assets:precompile"
    `RAILS_ENV=#{rails_env} bundle exec rake assets:precompile`
    `rsync -rlDzv --delete public/assets/ #{user}@#{domain}:#{shared_path}/public/assets/`
  end

  desc "Update gems"
  task :update_gems, :roles => :app do
    `ssh #{user}@#{domain} "cd #{current_path} && bundle update i_reach mail_manager newsletter"`
  end

  desc "Symlink shared resources"
  task :symlink_shared, :roles => :app do
    ['log','tmp','public/images','public/newsletter_assets','newsletters',
      'public/uploads',".env.#{rails_env}", 'public/assets'].each do |file|
      run "cd #{release_path} && rm -rf #{file} && ln -s #{shared_path}/#{file
        } #{file}" 
    end
  end
end


# namespace :rvm do
#   desc 'Trust rvmrc file'
#   task :trust_rvmrc, :roles => :app do
#     run "cd #{release_path} && rvm rvmrc trust #{current_release}"
#   end
# end


before "bundle:install", "deploy:symlink_shared"
after "bundle:install", "deploy:precompile_assets"
# before "bundle:install", "rvm:trust_rvmrc"
# after "rvm:trust_rvmrc", "deploy:symlink_shared"
# after "deploy:create_symlink", "deploy:update_crontab"
