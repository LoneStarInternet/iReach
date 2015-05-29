class ChangeAdminUsersToUsers < ActiveRecord::Migration
  def up
    rename_table :admin_users, :users
  end

  def down
    rename_table :users, :admin_users
  end
end
