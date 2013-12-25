class SemesterRole < ActiveRecord::Base
  belongs_to :member_semester
  belongs_to :role
end
