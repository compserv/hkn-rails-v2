# == Schema Information
#
# Table name: yearbooks
#
#  id               :integer          not null, primary key
#  year             :integer
#  created_at       :datetime
#  updated_at       :datetime
#  pdf_file_name    :string(255)
#  pdf_content_type :string(255)
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#

class Yearbook < ActiveRecord::Base
  has_attached_file :pdf
  validates_presence_of :year
  validates :pdf, attachment_presence: true

  def name
    year.to_s + ' Chapter Report'
  end
end
