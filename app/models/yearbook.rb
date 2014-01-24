class Yearbook < ActiveRecord::Base
  has_attached_file :pdf
  validates_presence_of :year
  validates :pdf, attachment_presence: true

  def name
    year.to_s + ' Chapter Report'
  end
end
