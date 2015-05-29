class CreateConventionAttendances < ActiveRecord::Migration
  def change
    create_table :convention_attendances do |t|
      t.integer :member_id
      t.integer :convention_id
      t.integer :ce_hours

      t.timestamps
    end
  end
end
