# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  department    :string(255)
#  course_number :integer
#  course_prefix :string(255)
#  course_suffix :string(255)
#  name          :string(255)
#  units         :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Course < ActiveRecord::Base
  has_many :course_offering
  has_many :course_semester, through: :course_offering
end
