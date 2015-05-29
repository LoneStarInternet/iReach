require 'csv'
class Course < ActiveRecord::Base
  has_many :course_completions
  attr_accessible :ce_hours, :description, :name, :number, :speakers, :video_url, :width, :height

  def video_name
    self[:video_name] || "IHS#{self[:id]}"
  end

  def wmv_video_file
    # Dir.glob(Conf.video_root + "/#{video_name}*wmv").first || 
    "#{Conf.video_root}/#{video_name}.wmv"
  end

  def wmv_video_uri
    "http://media.texashearingaids.org/download.php?file=/videos" + wmv_video_file.gsub(/^#{Conf.video_root}/,'')
  end

  def ogv_video_file
    # Dir.glob(Conf.video_root + "/#{video_name}*ogv").first || 
    "#{Conf.video_root}/#{video_name}.ogv"
  end

  def ogv_video_uri
    "http://media.texashearingaids.org/download.php?file=/videos" + ogv_video_file.gsub(/^#{Conf.video_root}/,'')
  end

  def mp4_video_file
    # Dir.glob(Conf.video_root + "/#{video_name}*mp4").first || 
    "#{Conf.video_root}/#{video_name}.mp4"
  end

  def mp4_video_uri
    "http://media.texashearingaids.org/download.php?file=/videos" + mp4_video_file.gsub(/^#{Conf.video_root}/,'')
  end


  def ce_hours_formatted
    "#{ce_hours} hr#{'s' if ce_hours > 1}."
  end

  def self.import(filename,has_header=true)
    header_skipped = nil
    CSV.open(filename,'r').each do |row|
      if has_header && !header_skipped
        header_skipped = true
        next
      end
      next unless row[0].present?
      Course.create!(
        number: row[0].to_s.strip,
        name: row[1].to_s.strip,
        ce_hours: row[2].to_i,
        speakers: row[3].to_s.strip,
        description: row[4].to_s.strip,
      )
    end
  end
end
