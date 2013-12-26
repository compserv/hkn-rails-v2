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
end
