# == Schema Information
#
# Table name: survey_question_responses
#
#  id                 :integer          not null, primary key
#  survey_question_id :integer
#  rating             :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class SurveyQuestionResponse < ActiveRecord::Base
  belongs_to :survey_question

  validates :survey_question_id, presence: true
  validates :rating
end
