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

require 'spec_helper'

describe CourseStaffMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
