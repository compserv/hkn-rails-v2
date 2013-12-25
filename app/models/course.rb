#
# department :string
# course_number :integer
# course_prefix :string
# course_suffix :string
# name: string
# units: integer
# created_at :datetime
# updated_at :datetime
#

class Course < ActiveRecord::Base
  has_many :course_offering
  has_many :course_semester, through: :course_offering
end
