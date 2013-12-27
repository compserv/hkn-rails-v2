# == Schema Information
#
# Table name: course_staff_members
#
#  id                 :integer          not null, primary key
#  course_offering_id :integer
#  staff_member_id    :integer
#  course_semester_id :integer
#  course_id          :integer
#  staff_role         :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class CourseStaffMember < ActiveRecord::Base
  belongs_to :course_offering
  belongs_to :staff_member
  has_many :course_surveys

  validates :staff_role, presence: true

  def add_survey
    course_surveys.create!(staff_member_id: staff_member_id,
                          course_offering_id: course_offering.id,
                          course_id: course_id,
                          course_semester_id: course_semester_id)
  end
end
