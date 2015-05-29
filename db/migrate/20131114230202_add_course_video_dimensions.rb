class AddCourseVideoDimensions < ActiveRecord::Migration
  def change
    add_column :courses, :width, :int, :after => :video_name
    add_column :courses, :height, :int, :after => :width
  end
end
