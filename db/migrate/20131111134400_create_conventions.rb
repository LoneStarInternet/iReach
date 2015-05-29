class CreateConventions < ActiveRecord::Migration
  def change
    create_table :conventions do |t|
      t.date :starts_on
      t.string :dshs_approval_number

      t.timestamps
    end
  end
end
