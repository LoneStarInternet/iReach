class CourseCompletion < ActiveRecord::Base
  belongs_to :member
  belongs_to :course
  attr_accessible :completed_at, :course_id, :member_id

  def name
    course.name
  rescue 
    ''
  end

  def number
    course.number
  rescue
    ''
  end

  def attended_on
    completed_at.to_date
  end

  def ce_hours
    course.ce_hours
  rescue 
    ''
  end

  def ce_hours_formatted
    course.ce_hours_formatted
  rescue 
    ''
  end
end
