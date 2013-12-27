# == Schema Information
#
# Table name: course_surveys
#
#  id                 :integer          not null, primary key
#  max_surveyors      :integer
#  status             :string(255)
#  staff_id           :integer
#  course_offering_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#  number_responses   :integer
#  survey_time        :datetime
#

class CourseSurvey < ActiveRecord::Base
  belongs_to :course_offering
  has_one :staff_member
  has_many :questions

  validates :staff_id, presence: true
  validates :course_offering_id, presence: true, uniqueness: true
  validates :number_responses, numericality: { greater_than_or_equal_to: 0 }
end
