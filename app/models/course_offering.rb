# == Schema Information
#
# Table name: course_offerings
#
#  id                 :integer          not null, primary key
#  course_id          :integer
#  course_semester_id :integer
#  lecture_number     :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class CourseOffering < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_semester
end
