Rails.application.config.to_prepare do
  begin 
    User.first
  rescue =>e
    User.table_name = 'admin_users'
    User.reset_column_information
  end
end
