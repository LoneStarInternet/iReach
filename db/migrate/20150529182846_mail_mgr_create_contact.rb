class MailMgrCreateContact < ActiveRecord::Migration
  def self.table_prefix
    MailManager.table_prefix
  rescue
    'mail_manager_'
  end

  def self.up
    create_table :"#{table_prefix}contacts" do |t|
      t.integer :contactable_id
      t.string :contactable_type
      t.string :email_address
      t.string :first_name
      t.string :last_name
      t.integer :upated_by
      t.integer :created_by
      t.timestamps
    end
    add_column :"#{table_prefix}subscriptions", :contact_id, :integer
    transaction do 
      MailManager::Subscription.all.each do |subscription|
        if subscription.contactable_type.eql?('MailManager::Subscription')
          contact = MailManager::Contact.
            find_by_email_address_and_contactable_type_and_contactable_id(subscription.email_address,nil,nil)
        else
          contact = MailManager::Contact.
            find_by_email_address_and_contactable_type_and_contactable_id(subscription.email_address,
            subscription.contactable_type, subscription.contactable_id)
        end
        if contact.nil?
          contact = MailManager::Contact.new(
            :first_name => subscription.first_name,
            :last_name => subscription.last_name,
            :email_address => subscription.email_address)
          contact.save!
        end
        unless subscription.contactable_type.eql?('MailManager::Subscription')
          contact.update_attribute(:contactable_type,subscription.contactable_type)
          contact.update_attribute(:contactable_id,subscription.contactable_id)
        end
        subscription.contact = contact
        subscription.save
      end
    end
    remove_column :"#{table_prefix}subscriptions", :first_name
    remove_column :"#{table_prefix}subscriptions", :last_name
    remove_column :"#{table_prefix}subscriptions", :email_address
    remove_column :"#{table_prefix}subscriptions", :contactable_type
    remove_column :"#{table_prefix}subscriptions", :contactable_id    
  end

  def self.down
    drop_table :"#{table_prefix}contacts"
    add_column :"#{table_prefix}subscriptions", :first_name, :string
    add_column :"#{table_prefix}subscriptions", :last_name, :string
    add_column :"#{table_prefix}subscriptions", :email_address, :string
    add_column :"#{table_prefix}subscriptions", :contactable_type, :string
    add_column :"#{table_prefix}subscriptions", :contactable_id, :integer
  end
end
