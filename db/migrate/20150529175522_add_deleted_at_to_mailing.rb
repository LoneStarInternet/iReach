class AddDeletedAtToMailing < ActiveRecord::Migration
  def table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end

  def change
    add_column :"#{table_prefix}mailings", :deleted_at, :datetime
  end
end
