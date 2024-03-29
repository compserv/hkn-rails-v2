# == Schema Information
#
# Table name: course_staff_members
#
#  id                 :integer          not null, primary key
#  course_offering_id :integer
#  staff_role         :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  staff_member_id    :integer
#

class CourseStaffMember < ActiveRecord::Base
  belongs_to :course_offering
  belongs_to :staff_member
  has_many :survey_question_responses
  STAFF_ROLES = ['ta', 'prof']

  validates :staff_role, presence: true, inclusion: { in: STAFF_ROLES,
      message: "%{value} is not a valid staff role" }
  validates :course_offering_id, presence: true

  def add_survey
    course_surveys.create!(staff_member_id: staff_member_id,
                          course_offering_id: course_offering.id,
                          course_id: course_id,
                          course_semester_id: course_semester_id)
  end
end
