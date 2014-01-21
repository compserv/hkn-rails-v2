# == Schema Information
#
# Table name: course_offerings
#
#  id                   :integer          not null, primary key
#  course_id            :integer
#  course_semester_id   :integer
#  created_at           :datetime
#  updated_at           :datetime
#  coursesurveys_active :boolean
#

class CourseOffering < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_semester
  has_many :course_staff_members
  has_many :course_surveys, through: :course_staff_members

  validates :course_id, presence: true
  validates :course_semester_id, presence: true

  def add_instructor(staff_member, staff_role)
    course_staff_members.create!(staff_member_id: staff_member.id,
                                 course_id: course_id,
                                 course_semester_id: course_semester_id,
                                 course_offering_id: id,
                                 staff_role: staff_role)
  end
end
