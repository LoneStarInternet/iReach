class CreateCourseCompletions < ActiveRecord::Migration
  def change
    create_table :course_completions do |t|
      t.integer :member_id
      t.integer :course_id
      t.timestamp :completed_at
    end
  end
end
