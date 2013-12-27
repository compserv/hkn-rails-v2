# == Schema Information
#
# Table name: staff_members
#
#  id                 :integer          not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  release_ta_surveys :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

class StaffMember < ActiveRecord::Base
  has_many :course_staff_members
  has_many :course_surveys, through: :course_staff_members

  validates :first_name, presence: true
  validates :last_name, presence: true

  after_initialize :init

  def find_surveys_by_semester(course_semester)
    return course_surveys.where("course_surveys.course_semester_id = #{course_semester.id}")
  end

  def init
    self.release_ta_surveys = false
  end
end
