#
# course_id :integer
# course_semester_id :integer
# location :string
# time :string
#

class Klass < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_semester
end
