# == Schema Information
#
# Table name: slideshows
#
#  id                     :integer          not null, primary key
#  member_semester_id     :integer
#  created_at             :datetime
#  updated_at             :datetime
#  slideshow_file_name    :string(255)
#  slideshow_content_type :string(255)
#  slideshow_file_size    :integer
#  slideshow_updated_at   :datetime
#

class Slideshow < ActiveRecord::Base
  belongs_to :member_semester
  has_attached_file :slideshow

  validates_presence_of :member_semester_id
end
