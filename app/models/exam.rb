# == Schema Information
#
# Table name: exams
#
#  id                :integer          not null, primary key
#  course_id         :integer
#  exam_type         :string(255)
#  number            :integer
#  is_solution       :boolean
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  year              :integer
#  semester          :string(255)
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

  validates_attachment_content_type :file,
      :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png", "application/pdf"],
      :message => "Oops, please use a jpg/gif/png/pdf"

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    # TODO make course_id an abbreviations when courses are added.
    "#{self.course_id}_#{self.semester}#{self.year}_" +
        "#{self.exam_type}#{self.number}#{self.is_solution ? '' : '_sol'}"
  end
end
