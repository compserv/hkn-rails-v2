# == Schema Information
#
# Table name: courses
#
#  id           :integer          not null, primary key
#  department   :string(255)
#  course_name  :string(255)
#  units        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  exams_count  :integer          default(0)
#  course_guide :text
#  name         :string(255)
#

class Course < ActiveRecord::Base
  DEPARTMENTS = ['EE', 'MATH', 'PHYS', 'CS']
  has_many :course_offerings
  has_many :exams, through: :course_offerings
  has_many :course_semesters, through: :course_offerings
  has_many :course_surveys, through: :course_offerings
  has_many :course_staff_members, through: :course_offerings

  validates :department, presence: true
  validates :course_name, presence: true

  def add_offering(course_semester)
    course_offerings.create!(course_semester_id: course_semester.id)
  end

  def course_abbr
    # e.g. EE20N
    "#{department}#{course_name}"
  end

  def to_s
    course_abbr
  end

  def course_number
    # e.g. EE20N
    course_name.gsub(/\D/, '').to_i
  end
  def course_suffix
    # e.g. EE20N
    course_name.gsub(/\d/, '')
  end

end
