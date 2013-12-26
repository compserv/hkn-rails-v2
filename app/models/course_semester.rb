# == Schema Information
#
# Table name: course_semesters
#
#  id         :integer          not null, primary key
#  season     :string(255)
#  year       :integer
#  created_at :datetime
#  updated_at :datetime
#

class CourseSemester < ActiveRecord::Base
  has_many :course_offering
  has_many :course, through: :course_offering

  validates :season, presence: true
  validates :year, presence: true
end
