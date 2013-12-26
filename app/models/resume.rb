# == Schema Information
#
# Table name: resumes
#
#  id                  :integer          not null, primary key
#  overall_gpa         :decimal(, )
#  major_gpa           :decimal(, )
#  resume_text         :text
#  graduation_year     :integer
#  graduation_semester :string(255)
#  user_id             :integer
#  included            :boolean
#  created_at          :datetime
#  updated_at          :datetime
#  file_file_name      :string(255)
#  file_content_type   :string(255)
#  file_file_size      :integer
#  file_updated_at     :datetime
#

class Resume < ActiveRecord::Base
  belongs_to :user
  validates :overall_gpa, :presence => true, :numericality => true
  validates :overall_gpa, :numericality => true
  validates :resume_text, :presence => true
  validates :graduation_year, :numericality => true
  validates :graduation_semester, inclusion: { in: %w(Spring Fall),
      message: "%{value} is not a valid semester" }
  validates :included, :inclusion => [true,false]

  has_attached_file :file, :default_url => '/resumes/new',
      :path => ":rails_root/public/resumes/:normalized_file_name.:extension",
      :url => "/resumes/:normalized_file_name.:extension"

  validates_attachment_presence :file

  validates_attachment_content_type :file,
      :content_type => "application/pdf",
      :message => "Oops, please use a pdf"

  validate :valid_gpas?

  default_scope :order => 'resumes.created_at DESC'
  # so we can just pick out the 'first' of the resumes to get the most recent


  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    "#{self.user.username}/#{self.created_at}"
  end

  def valid_gpas?
    unless overall_gpa >= 0 && overall_gpa <= 4
      errors.add(:overall_gpa, "Please use a valid gpa")
    end
    unless graduation_year >= 1915 && graduation_year <= 2037
      errors.add(:graduation_year, "Please use a valid graduation_year")
    end
    if major_gpa && (major_gpa < 0.0 || major_gpa > 4.0)
      errors.add(:major_gpa, "If included please use a valid gpa")
    end
  end
end
