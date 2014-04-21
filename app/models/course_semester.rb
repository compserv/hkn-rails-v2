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
  has_many :course_surveys, through: :course_offerings

  SEASONS = ['Fall', 'Spring', 'Summer']
  validates :season, inclusion: { in: SEASONS,
      message: "%{value} is not a valid semester" }
  validates :year, presence: true

  class << self
    def current
      # TODO(mark): This isn't always the case, but works for now.
      last
    end
  end

  def name
    "#{season} #{year}"
  end
end
