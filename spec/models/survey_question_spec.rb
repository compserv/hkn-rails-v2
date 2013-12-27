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

require 'spec_helper'

describe SurveyQuestion do
  pending "add some examples to (or delete) #{__FILE__}"
end
