class MailMgrTestMessage < ActiveRecord::Migration
  def self.table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end

  def self.up
    change_table :"#{table_prefix}messages" do |t|
      # t.string :type
      # t.string :test_email_address
      t.integer :contact_id
    end
  end

  def self.down
    change_table :"#{table_prefix}messages" do |t|
      # t.remove :type
      # t.remove :test_email_address
      t.remove :contact_id
    end
  end
end