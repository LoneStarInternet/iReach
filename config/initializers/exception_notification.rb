from_address = (Rails.env.production? ? %{"THAA Error" <alert@lnstar.com>} : 
  %{"Dev THAA Error" <alert@lnstar.com>})
Rails.application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[THAA News] ",
    :sender_address => from_address,
    :exception_recipients => %w{alert@lnstar.com}
  }
