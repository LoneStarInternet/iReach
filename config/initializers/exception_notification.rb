from_address = (Rails.env.production? ? %{"#{Rails.application.name} Error" <alert@lnstar.com>} : 
  %{"Dev #{Rails.application.name} Error" <alert@lnstar.com>})
Rails.application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[Lone Star News] ",
    :sender_address => from_address,
    :exception_recipients => %w{alert@lnstar.com}
  }
