# == Schema Information
#
# Table name: survey_questions
#
#  id            :integer          not null, primary key
#  question_text :string(255)
#  keyword       :string(255)
#  mean_score    :float
#  created_at    :datetime
#  updated_at    :datetime
#  max           :integer
#

class SurveyQuestion < ActiveRecord::Base
  has_many :survey_question_responses
  validates_presence_of :question_text, :keyword, :max

end
