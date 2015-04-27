require 'role_model'
class User < ActiveRecord::Base
  include RoleModel
  roles_attribute :roles_mask
  roles :admin, :mail_manager, :newsletter, :designer

  # Here is how you might tie a user to a contact
  # see also the Registering below
  # include MailManager::ContactableRegistry::Contactable
  #
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, 
    :remember_me, :roles
end

# Here is how you might tie a user to a contact
# see also the include above
#MailManager::ContactableRegistry.register_contactable("User",{
#  first_name: :first_name,
#  last_name: :last_name,
#  email_address: :email
#})

