class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :number
      t.integer :ce_hours
      t.text :speakers
      t.text :description
      t.string :video_name
      t.timestamps
    end
  end
end
