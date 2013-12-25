# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  department  :string(255)
#  course_name :string(255)
#  units       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Course < ActiveRecord::Base
  has_many :course_offering
  has_many :course_semester, through: :course_offering

  validates :department, presence: true
  validates :course_name, presence: true
end
