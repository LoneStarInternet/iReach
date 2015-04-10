require 'role_model'
class User < ActiveRecord::Base
  include RoleModel
  roles_attribute :roles_mask
  roles :admin, :mail_manager, :newsletter, :design
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles_mask


end
