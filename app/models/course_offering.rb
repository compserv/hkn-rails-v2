#
# course_id           :integer
# course_semester_id  :integer
# lecture_number      :integer
#
class CourseOffering < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_semester
end
