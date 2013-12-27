# == Schema Information
#
# Table name: survey_questions
#
#  id               :integer          not null, primary key
#  course_survey_id :integer
#  question_text    :string(255)
#  keyword          :string(255)
#  mean_score       :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class SurveyQuestion < ActiveRecord::Base
  has_many :survey_question_responses
  belongs_to :course_survey

  validates :course_survey_id, presence:true
  validates :question_text, presence:true
  validates :keyword, presence:true
end
