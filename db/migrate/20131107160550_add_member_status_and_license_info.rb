class AddMemberStatusAndLicenseInfo < ActiveRecord::Migration
  def up
    change_table :members do |t|
      t.string  :license_number
      t.string  :membership_status
    end
  end

  def down
    remove_column  :members, :license_number
    remove_column  :members, :membership_status
  end
end
