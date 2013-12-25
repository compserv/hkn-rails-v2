#
# department :string
# course_name: string
# units: integer
# created_at :datetime
# updated_at :datetime
#

class Course < ActiveRecord::Base
  has_many :course_offering
  has_many :course_semester, through: :course_offering
end
