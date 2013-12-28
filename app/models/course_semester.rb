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
  has_many :course_offerings
  has_many :courses, through: :course_offerings

  validates :season, presence: true
  validates :year, presence: true
end
