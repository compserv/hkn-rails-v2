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
#  iso_file_name    :string(255)
#  iso_content_type :string(255)
#  iso_file_size    :integer
#  iso_updated_at   :datetime
#

class ResumeBook < ActiveRecord::Base
  serialize :details
  validates_presence_of :cutoff_date, :title, :details
  has_many :resume_book_urls

  has_attached_file :pdf, :default_url => '/',
      :path => ":rails_root/private/resume_books/:normalized_file_name.:extension",
      :url => '/:class/:id/download_pdf'

  has_attached_file :iso, :default_url => '/',
      :path => ":rails_root/private/resume_books/:normalized_file_name.:extension",
      :url => '/:class/:id/download_iso'

  validates_attachment_presence :pdf, :iso

  validates_attachment_content_type :pdf,
      :content_type => "application/pdf",
      :message => "Oops, please use a pdf"

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    "#{self.title}/#{self.updated_at}"
  end

  def total_download_count
    sum = 0
    self.resume_book_urls.each do |url|
      sum = sum + url.download_count
    end
    sum
  end

  def save_for_paperclip(path, type)
    template = File.read(path) # grab the created file, going to save w/ paperclip

    file = StringIO.new(template) # mimic a real upload file for paperclip
    file.class.class_eval { attr_accessor :original_filename, :content_type } # add attr's that paperclip needs
    file.content_type = type
    if type == "application/pdf"
      file.original_filename = "#{self.title}.pdf"
      self.pdf = file
    else
      file.original_filename = "#{self.title}.iso"
      self.iso = file
    end
  end

end
