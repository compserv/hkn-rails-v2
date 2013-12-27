# == Schema Information
#
# Table name: staff_members
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class StaffMember < ActiveRecord::Base
  has_many :course_staff_member
  has_many :course_survey, through: :course_staff_member

  def find_surveys_by_semester(course_semester)
    return course_survey.where("course_surveys.course_semester_id = #{course_semester.id}")
  end
end
