# == Schema Information
#
# Table name: exams
#
#  id                     :integer          not null, primary key
#  course_id              :integer          not null, foreign_key
#  exam_type              :string           not null
#  created_at             :datetime
#  updated_at             :datetime
#  number                 :integer
#  is_solution            :boolean
#  file_file_name         :string
#  file_content_type      :string
#  file_file_size         :string
#  file_updated_at        :datetime
#  year                   :integer
#  semester               :semester
#

class Exam < ActiveRecord::Base
  # TODO belongs_to course
  # has_many staff
  validates :exam_type, presence: true
  validates :year, presence: true
  validates :semester, inclusion: { in: %w(sp su fa), 
      message: "%{value} is not a valid semester" }
  validates :exam_type, inclusion: { in: %w(q mt f), 
      message: "%{value} is not a valid exam type" }
  validates_uniqueness_of :exam_type, 
      :scope => [:semester, :number, :is_solution, :year, :course_id], 
      :message => "This exam appears to be in the database already"

  has_attached_file :file, :default_url => '/exams',
      :path => ":rails_root/public/examfiles/:normalized_file_name.:extension",
      :url => "/examfiles/:normalized_file_name.:extension"

  validates_attachment_presence :file

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    # TODO make course_id an abbreviations when courses are added.
    "#{self.course_id}_#{self.semester}#{self.year}_" +
        "#{self.exam_type}#{self.number}/#{self.is_solution ? '' : '_sol'}"
  end
end
