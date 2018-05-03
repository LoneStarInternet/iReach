class AddLoginTokenToContact < ActiveRecord::Migration
  def table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end
  def change
    add_column :"#{table_prefix}contacts", :login_token, :string
    add_column :"#{table_prefix}contacts", :login_token_created_at, :datetime
  end
end
