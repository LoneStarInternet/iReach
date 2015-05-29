class Convention < ActiveRecord::Base
  attr_accessible :dshs_approval_number, :starts_on
  has_many :convention_attendances

  def name
    "#{starts_on.year} Annual Convention"
  end

  def number
    dshs_approval_number
  end

  def year
    starts_on.year
  end
end
