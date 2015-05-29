class ConventionAttendance < ActiveRecord::Base
  attr_accessible :ce_hours, :convention_id, :member_id
  belongs_to :member
  belongs_to :convention

  def number
    convention.number
  end

  def ihs_program_number
    convention.ihs_program_number
  end

  def attended_on
    convention.starts_on
  end

  def name
    convention.name
  end

  def ce_hours_formatted
    "#{ce_hours.to_i} hr#{'s' if ce_hours.to_i > 1}."
  end

  def year
    attended_on.year
  end
end
