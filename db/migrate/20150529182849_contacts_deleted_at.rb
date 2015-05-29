class ContactsDeletedAt < ActiveRecord::Migration
  def self.table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end

  def self.up
    add_column :"#{table_prefix}contacts", :deleted_at, :datetime
  end

  def self.down
    remove_column :"#{table_prefix}contacts", :deleted_at
  end
end
