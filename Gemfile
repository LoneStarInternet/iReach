source 'https://rubygems.org'

gem 'rails', '3.2.21'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

# Set gems for local testing
if ENV['MAIL_MANAGER_GEM_PATH']
  gem 'mail_manager', path: ENV['MAIL_MANAGER_GEM_PATH']
else
  gem 'mail_manager', git: "ssh://git@bender.lnstar.com/var/git/mail_manager.git", branch: "rails3.2.x"
end
if ENV['NEWSLETTER_GEM_PATH']
  gem 'newsletter', path: ENV['NEWSLETTER_GEM_PATH']
else
  gem 'newsletter', git: "ssh://git@bender.lnstar.com/var/git/newsletter.git", branch: "rails3.2.x"
end
if ENV['IREACH_GEM_PATH']
  gem 'i_reach', path: ENV['IREACH_GEM_PATH']
else
  gem 'i_reach', git: 'ssh://git@bender.lnstar.com/var/git/i_reach', branch: 'rails3.2.x'
end
gem 'devise'
gem 'role_model'
gem "delayed_job_web"
gem 'quiet_assets'
gem 'spring'
gem 'dotenv-rails'
gem 'pry-rails'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'debugger'
