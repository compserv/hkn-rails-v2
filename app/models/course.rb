# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  department  :string(255)
#  course_name :string(255)
#  units       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Course < ActiveRecord::Base
  has_many :course_offering
  has_many :course_semester, through: :course_offering
  has_many :course_survey, through: :course_offering

  validates :department, presence: true
  validates :course_name, presence: true

  def add_offering(course_semester)
    course_offering.create!(course_semester_id: course_semester.id)
  end
end
