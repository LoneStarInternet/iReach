require File.dirname(__FILE__) + '/lib/app_config'

unless Object.const_defined?(:Conf)
  c = AppConfig.new
  c.use_file!("#{Rails.root}/config/config.yml")
  c.use_file!("#{Rails.root}/config/config.local.yml")
  c.use_section!(Rails.env)
  ::Conf = c
end
