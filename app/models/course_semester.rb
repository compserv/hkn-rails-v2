#
# year :integer
# season :string
#

class CourseSemester < ActiveRecord::Base
  has_many :klass
  has_many :course, through: :klass
end
