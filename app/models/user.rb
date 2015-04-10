require 'role_model'
class User < ActiveRecord::Base
  include RoleModel
  include MailManager::ContactableRegistry::Contactable
  roles_attribute :roles_mask
  roles :admin, :mail_manager, :newsletter, :designer
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, 
    :remember_me, :roles
end

MailManager::ContactableRegistry.register_contactable("User",{
  first_name: :first_name,
  last_name: :last_name,
  email_address: :email
})

