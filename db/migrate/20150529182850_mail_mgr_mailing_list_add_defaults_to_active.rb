class MailMgrMailingListAddDefaultsToActive < ActiveRecord::Migration
  def self.table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end

  def self.up
    add_column :"#{table_prefix}mailing_lists", :defaults_to_active, :boolean
  end

  def self.down
    remove_column :"#{table_prefix}mailing_lists", :defaults_to_active
  end
end
