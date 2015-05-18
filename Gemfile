source 'https://rubygems.org'

gem 'rails', '3.2.21'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

# Set gems for local testing
#gem 'mail_manager', path: '/home/httpd/mail_manager'
#gem 'newsletter', path: '/home/httpd/newsletter'
#gem 'i_reach', path: '/home/httpd/i_reach'
# Set gems for bender refs 
gem 'mail_manager', git: 'ssh://git@bender.lnstar.com/var/git/mail_manager.git', ref: 'e893a'
gem 'newsletter', git: 'ssh://git@bender.lnstar.com/var/git/newsletter.git', ref: '116e5' 
gem 'i_reach', git: 'ssh://git@bender.lnstar.com/var/git/i_reach.git', ref: '3e939'
#gem 'i_reach', "~>3.2"
gem 'devise'
gem 'role_model'
gem "delayed_job_web"
gem 'quiet_assets'
# gem 'spring'
gem 'dotenv-rails'
gem 'pry-rails'
gem 'exception_notification'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3', "~>0.3.x"
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn-rails'

# Deploy with Capistrano
# gem 'capistrano'
group :development do
  gem 'airbrussh', :require => false
  gem 'capistrano', "~>2.15.0"
  #gem 'capistrano-rails', "~>2.2"
  gem 'capistrano-ext', "~>1.2.1"
  gem 'capistrano-unicorn', "~>0.2.0", require: false
  gem 'rvm-capistrano', "~>1.3.0", require: false
  #gem 'capistrano-bundler', '~> 1.1.2'
  #gem 'capistrano3-unicorn'
  #gem 'capistrano-faster-assets', '~> 1.0'
  #gem 'capistrano-rvm', require: false
  #gem 'rvm1-capistrano3', require: false
  gem 'hipchat'
end



# To use debugger
# gem 'debugger'
