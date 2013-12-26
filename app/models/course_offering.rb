# == Schema Information
#
# Table name: course_offerings
#
#  id                 :integer          not null, primary key
#  course_id          :integer
#  course_semester_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class CourseOffering < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_semester
  has_many :course_staff_member

  validates :course_id, presence: true
  validates :course_semester_id, presence: true
end
