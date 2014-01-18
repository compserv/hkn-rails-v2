# == Schema Information
#
# Table name: course_offerings
#
#  id                 :integer          not null, primary key
#  course_id          :integer
#  course_semester_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#  section            :string(255)
#  time               :string(255)
#  location           :string(255)
#  num_students       :integer
#  notes              :text
#

require 'spec_helper'

describe CourseOffering do
  pending "add some examples to (or delete) #{__FILE__}"
end
