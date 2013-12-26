# == Schema Information
#
# Table name: course_staff_members
#
#  id                   :integer          not null, primary key
#  course_offering_id   :integer
#  staff_member_user_id :integer
#  staff_role           :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class CourseStaffMember < ActiveRecord::Base
  belongs_to :course_offering
  belongs_to :staff_member

  validates :staff_role, presence: true
end
