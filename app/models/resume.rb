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
  validates :overall_gpa,
      :numericality => { greater_than_or_equal_to: 0, less_than_or_equal_to: 4 }
  validates :major_gpa,
      :numericality => { greater_than_or_equal_to: 0, less_than_or_equal_to: 4 },
      :allow_nil => true
  validates :resume_text, :presence => true
  validates :graduation_year,
      :numericality => { greater_than_or_equal_to: 1915, less_than_or_equal_to: 2037 }
  validates :graduation_semester,
      inclusion: { in: %w(Spring Fall),
      message: "%{value} is not a valid semester" }
  validates :included, :inclusion => [true,false]
  validates :user_id, presence: true, uniqueness: true

  has_attached_file :file, :default_url => '/resumes/new',
      :path => ":rails_root/public/resumes/:normalized_file_name.:extension",
      :url => "/resumes/:normalized_file_name.:extension"

  validates_attachment_presence :file

  validates_attachment_content_type :file,
      :content_type => "application/pdf",
      :message => "Oops, please use a pdf"

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    "#{self.user.username}/#{self.created_at}"
  end

  def get_username
    self.user.username
  end
end
