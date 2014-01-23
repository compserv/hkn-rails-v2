# == Schema Information
#
# Table name: exams
#
#  id                 :integer          not null, primary key
#  course_offering_id :integer
#  exam_type          :string(255)
#  number             :integer
#  is_solution        :boolean
#  created_at         :datetime
#  updated_at         :datetime
#  file_file_name     :string(255)
#  file_content_type  :string(255)
#  file_file_size     :integer
#  file_updated_at    :datetime
#  year               :integer
#  semester           :string(255)
#

class Exam < ActiveRecord::Base
  belongs_to :course_offering
  validates_presence_of :exam_type, :course_offering_id
  validates :exam_type, inclusion: { in: %w(q mt f),
      message: "%{value} is not a valid exam type" }
  validates_uniqueness_of :exam_type,
      :scope => [:number, :is_solution, :course_offering_id],
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
    "#{self.course_offering.course.course_abbr}_#{self.course_offering.course_semester.season}#{self.course_offering.course_semester.year}_" +
        "#{self.exam_type}#{self.number}#{self.is_solution ? '' : '_sol'}"
  end

  def short_content_type 
    file_content_type.split("/")[1].to_sym
  end

  def short_type
    "#{exam_type}#{number}"
  end

  def save_for_paperclip(path, type)
    template = File.read(path) # grab the created file, going to save w/ paperclip

    file = StringIO.new(template) # mimic a real upload file for paperclip
    file.class.class_eval { attr_accessor :original_filename, :content_type } # add attr's that paperclip needs
    file.content_type = type
    if type == "application/pdf"
      file.original_filename = "hi.pdf"
      self.file = file
    else
      file.original_filename = "hi.iso"
      self.file = file
    end
  end

end
