class MailMgrInitial < ActiveRecord::Migration
  def self.table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end

  def self.up
    create_table :"#{table_prefix}mailing_lists" do |t|
      t.string :name
      t.text :description
      t.string :status
      t.datetime :status_changed_at
      t.timestamps
    end
    create_table :"#{table_prefix}subscriptions" do |t|
      t.integer :contactable_id
      t.string  :contactable_type
      t.string  :first_name
      t.string  :last_name
      t.string  :email_address
      t.integer :mailing_list_id
      t.string :status
      t.datetime :status_changed_at
      t.integer :updated_by
      t.timestamps
    end
    
    create_table :"#{table_prefix}mailings" do |t|
      t.string :subject
      t.string :from_email_address
      t.string :mailable_type
      t.integer :mailable_id
      t.string :status
      t.datetime :status_changed_at
      t.datetime :scheduled_at
      t.boolean :include_images
      t.timestamps
    end
    
    create_table :"#{table_prefix}mailing_lists_#{table_prefix}mailings", :id => false do |t|
      t.integer :mailing_id
      t.integer :mailing_list_id
    end
    create_table :"#{table_prefix}messages" do |t|
      t.string  :type
      t.string  :test_email_address
      t.integer :subscription_id
      t.integer :mailing_id
      t.string :guid
      t.string :status
      t.datetime :status_changed_at
      t.text :result
      t.timestamps
    end
    create_table :"#{table_prefix}bounces" do |t|
      t.integer :message_id
      t.integer :mailing_id
      t.string :status
      t.datetime :status_changed_at
      t.text :bounce_message
      t.text :comments
      t.timestamps
    end
    create_table :"#{table_prefix}mailables" do |t|
      t.string    :name, :null => false
      t.text      :email_html
      t.text      :email_text
      t.boolean   :reusable  
      t.integer   :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :"#{table_prefix}mailables"
    drop_table :"#{table_prefix}bounces"
    drop_table :"#{table_prefix}messages"
    drop_table :"#{table_prefix}mailing_lists_#{table_prefix}mailings"
    drop_table :"#{table_prefix}mailings"
    drop_table :"#{table_prefix}subscriptions"
    drop_table :"#{table_prefix}mailing_lists"
  end
end
