class MailMgrMessageAddFromEmailAddress < ActiveRecord::Migration
  def self.table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end

  def self.up
    add_column :"#{table_prefix}messages", :from_email_address, :string
  end

  def self.down
    remove_column :"#{table_prefix}messages", :from_email_address
  end
end
