class Exam < ActiveRecord::Base
  # TODO belongs_to course
  # has_many staff
  has_attached_file :file, :default_url => "/public/images/crossed_out.png"
end
