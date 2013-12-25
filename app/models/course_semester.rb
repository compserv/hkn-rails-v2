#
# year :integer
# season :string
#

class CourseSemester < ActiveRecord::Base
  has_many :course_offering
  has_many :course, through: :course_offering
end
