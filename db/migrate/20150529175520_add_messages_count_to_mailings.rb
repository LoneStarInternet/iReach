class AddMessagesCountToMailings < ActiveRecord::Migration
  def table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end
  def change
    add_column :"#{table_prefix}mailings", :messages_count, :integer, default: 0
    MailManager::Mailing.reset_column_information
    MailManager::Mailing.find_each do |m|
      MailManager::Mailing.reset_counters m.id, :messages
    end
  end
end
