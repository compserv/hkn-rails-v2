# == Schema Information
#
# Table name: resume_books
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  remarks          :string(255)
#  details          :text
#  cutoff_date      :date
#  created_at       :datetime
#  updated_at       :datetime
#  pdf_file_name    :string(255)
#  pdf_content_type :string(255)
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#

class ResumeBook < ActiveRecord::Base

  validates_presence_of :cutoff_date, :title, :details

  has_attached_file :pdf, :default_url => '/',
      :path => ":rails_root/private/resumes_book/:normalized_file_name.:extension",
      :url => '/:class/:id/download_pdf'

  validates_attachment_presence :pdf

  validates_attachment_content_type :pdf,
      :content_type => "application/pdf",
      :message => "Oops, please use a pdf"

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    "#{self.title}"
  end

end
