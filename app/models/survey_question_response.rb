# == Schema Information
#
# Table name: survey_question_responses
#
#  id                     :integer          not null, primary key
#  survey_question_id     :integer
#  rating                 :integer
#  created_at             :datetime
#  updated_at             :datetime
#  number_responses       :integer
#  course_staff_member_id :integer
#

class SurveyQuestionResponse < ActiveRecord::Base
  belongs_to :survey_question
  belongs_to :course_staff_member

  validates :survey_question_id, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 7 }
end
