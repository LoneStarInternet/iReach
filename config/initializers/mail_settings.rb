IReach::Application.config.to_prepare do
  IReach::Application.config.action_mailer.default_url_options = { :host => URI.parse(MailManager.site_url).host, :protocol => URI.parse(MailManager.site_url).scheme }
end
