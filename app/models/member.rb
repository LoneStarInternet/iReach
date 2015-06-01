# encoding: UTF-8
#require 'pdf'
class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

   belongs_to :membership_type
   has_many :course_completions, dependent: :destroy
   has_many :convention_attendances

   validates_presence_of :first_name, :last_name, :mailing_address, :mailing_city, :mailing_state, :mailing_zip, 
                           :membership_type_id, :business_name, :business_address, :business_state, :business_zip,
                           :business_phone
   validates_uniqueness_of :email
   validates_format_of  :email, 
                        :with => /^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_-]+(\.?))+([a-zA-Z0-9_-]+)(\.[a-zA-Z0-9_-])+/
   validate :validate_password_change

  devise :database_authenticatable, :recoverable

  after_create :generate_initial_reset_password
    #:registerable,     #:recoverable, :rememberable, :trackable, :validatable

  # here is some code if we decide to JS poll for pdf creation(thru delayed Job):
  # def generating_personal_tracking_report?(license_renewal_date)
  #   false
  # end

  # def personal_tracking_report_generated?(license_renewal_date)
  #   false
  # end

  # def personal_tracking_report_filename(license_renewal_date)
  #   renewal_date = Date.parse(license_renewal_date)
  #   newest_course = self.course_completions.where("DATE(completed_at) <= ?", renewal_date).order("completed_at desc").first
  # end

  def can_complete_courses?
    membership_status.eql?('Site + CE')
  end

  def convention_attendances=(convention_years)
    convention_years.each_pair do |year,ce_hours_hash|
      ce_hours = ce_hours_hash.values.first
      convention = Convention.all.detect{|convention| convention.year.eql?(year.to_i)}
      attendance = self.convention_attendances.detect{|attendance| attendance.year.eql?(year.to_i)}
      next unless attendance.present? || ce_hours.to_i > 0
      attendance ||= self.convention_attendances.build(convention_id: convention.id, ce_hours: ce_hours)
      attendance.update_attribute(:ce_hours, ce_hours)
    end
  end

  def convention_ce_hours_for_year(year)
    attendance = self.convention_attendances.detect{|attendance| attendance.year.eql?(year.to_i)}
    attendance.ce_hours
  rescue => e
    0
  end

  def convention_2012_ce_hours
    convention_ce_hours_for_year(2012)
  end

  def convention_2012_ce_hours=(ce_hours)
    convention = Convention.all.detect{|convention| convention.year.eql?(2012)}
    attendance = self.convention_attendances.detect{|attendance| attendance.year.eql?(2012)}
    return unless attendance.present? || ce_hours.to_i > 0
    attendance ||= self.convention_attendances.build(convention_id: convention.id, ce_hours: ce_hours)
    attendance.update_attribute(:ce_hours, ce_hours)
  end  

  def convention_2013_ce_hours
    convention_ce_hours_for_year(2013)
  end

  def convention_2013_ce_hours=(ce_hours)
    convention = Convention.all.detect{|convention| convention.year.eql?(2013)}
    attendance = self.convention_attendances.detect{|attendance| attendance.year.eql?(2013)}
    return unless attendance.present? || ce_hours.to_i > 0
    attendance ||= self.convention_attendances.build(convention_id: convention.id, ce_hours: ce_hours)
    attendance.update_attribute(:ce_hours, ce_hours)
  end  

  def convention_2014_ce_hours
    convention_ce_hours_for_year(2014)
  end

  def convention_2014_ce_hours=(ce_hours)
    convention = Convention.all.detect{|convention| convention.year.eql?(2014)}
    attendance = self.convention_attendances.detect{|attendance| attendance.year.eql?(2014)}
    return unless attendance.present? || ce_hours.to_i > 0
    attendance ||= self.convention_attendances.build(convention_id: convention.id, ce_hours: ce_hours)
    attendance.update_attribute(:ce_hours, ce_hours)
  end

  def convention_2015_ce_hours
    convention_ce_hours_for_year(2015)
  end

  def convention_2015_ce_hours=(ce_hours)
    convention = Convention.all.detect{|convention| convention.year.eql?(2015)}
    attendance = self.convention_attendances.detect{|attendance| attendance.year.eql?(2015)}
    return unless attendance.present? || ce_hours.to_i > 0
    attendance ||= self.convention_attendances.build(convention_id: convention.id, ce_hours: ce_hours)
    attendance.update_attribute(:ce_hours, ce_hours)
  end

  def parse_renewal_date(license_renewal_date)
    Date.parse(license_renewal_date)
  end

  def personal_tracking_report(license_renewal_date)
    courses = ''
    completed_ces_for_date(license_renewal_date).each do |course_completion|
        if course_completion.is_a?(CourseCompletion)
courses += <<EOT
Course Completion Date: #{course_completion.completed_at.strftime("%B %d, %Y")}
DSHS Course No: #{course_completion.number}
Course Name: #{course_completion.name}
CE Hours: #{course_completion.ce_hours_formatted}

EOT
        elsif course_completion.is_a?(ConventionAttendance)
courses += <<EOT
#{course_completion.name}: #{course_completion.attended_on.strftime("%B %d, %Y")}
DSHS Program No.: #{course_completion.number}
EOT
          if course_completion.ihs_program_number.present?
            courses << "IHS Program No.: #{course_completion.ihs_program_number}\n"
          end
courses += <<EOT
CE Hours: #{course_completion.ce_hours_formatted}

EOT
        end
      end
    strings = {
      name: full_name.to_s.upcase,
      license: "LICENSE NO. " + license_number.to_s,
      courses: courses
    }
    PDF.base_directory = Conf.tmp_directory 
    pdf_file = PDF::fill_in('media/THAA_PTR_form.pdf',strings,{},true, 'personal_tracking_report')
    PDF::lock(pdf_file.path,'bobdoleisawesome','personal_tracking_report_locked')
  end


  def validate_password_change
    return true unless password.present? || password_confirmation.present?
    unless password.to_s.strip == password_confirmation.to_s.strip
      self.errors.add :password, "doesn't match!"
    end
    unless password.to_s.strip.length >= 8
      self.errors.add :password, "must be at least 8 characters long!"
    end
    true
  end

  def completed_ces_for_date(license_renewal_date)
    renewal_date = parse_renewal_date(license_renewal_date)
    earliest_course_date = renewal_date - 2.years + 1
    completed_ces.reject{|ce| ce.attended_on < earliest_course_date || ce.attended_on > renewal_date}
  end

  def completed_ces
    (self.course_completions.reject{|c| c.course.nil?} + self.convention_attendances).select(&:present?).uniq.sort do |a,b|
      b.attended_on <=> a.attended_on
    end.reject{|completed| completed.ce_hours.to_i <= 0 }
  end

  def completed_course_hours_since(since=2.years.ago)
    course_completions.where("completed_at >= ?",since).map(&:ce_hours).sum 
  end

  def completed_convention_hours_since(since=2.years.ago)
    convention_attendances.select{|ca| ca.convention.starts_on.end_of_day >= since}.map(&:ce_hours).sum
  end

  def completed_ce_hours
    completed_ces.map(&:ce_hours).sum
  end

  def has_completed_course?(course)
    self.course_completions.where(course_id: course.id).first.present?
  end

  def course_completed_on(course)
    self.course_completions.where(course_id: course.id).first.completed_at.strftime("%B %d, %Y")
  end

  def full_name
    "#{first_name} #{last_name}".strip.gsub(/\s+/,' ')
  end

  #attr_accessible :membership_status, :license_number, :password, :first_name, 
  #  :last_name, :mailing_address, :mailing_city, :mailing_state, :mailing_zip, 
  #  :email, :membership_type_id, :business_name, :business_address, :business_city, 
  #  :business_state, :business_zip, :business_phone, :convention_2015_ce_hours, 
  #  :convention_2014_ce_hours, :convention_2013_ce_hours, :convention_2012_ce_hours, :password_confirmation


  include MailManager::ContactableRegistry::Contactable
  attr_protected :id, :reset_password_token, :reset_password_sent_at, :encrypted_password
  
  def generate_initial_reset_password
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = 2.days.from_now
    self.save(:validate => false)
  end
end

MailManager::ContactableRegistry.register_contactable(Member,
{
  :first_name => :first_name,
  :last_name => :last_name,
  :email_address => :email
})


# old Member
# class Member < ActiveRecord::Base

   # belongs_to :membership_type

   # validates_presence_of :first_name, :last_name, :mailing_address, :mailing_city, :mailing_state, :mailing_zip, 
   #                         :membership_type_id, :business_name, :business_address, :business_state, :business_zip,
   #                         :business_phone
   # validates_uniqueness_of :email_address
   # validates_format_of  :email_address, 
   #                      :with => /^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_-]+(\.?))+([a-zA-Z0-9_-]+)(\.[a-zA-Z0-9_-])+/

   # include MailManager::ContactableRegistry::Contactable
   # def self.authenticate( userid, password )

   #   if ( !userid )
   #      user = self.find_by_password( password )

   #   else 
   #      user = self.find( userid )
   #   end

   #   if user

   #      user 
   #   end

   # end

# end

