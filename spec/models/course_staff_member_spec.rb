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

require 'spec_helper'

describe CourseStaffMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
