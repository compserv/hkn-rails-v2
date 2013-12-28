# == Schema Information
#
# Table name: course_surveys
#
#  id                     :integer          not null, primary key
#  staff_member_id        :integer
#  course_staff_member_id :integer
#  course_offering_id     :integer
#  course_id              :integer
#  course_semester_id     :integer
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe CourseSurvey do
  pending "add some examples to (or delete) #{__FILE__}"
end
