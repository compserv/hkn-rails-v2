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

require 'spec_helper'

describe SurveyQuestionResponse do
  pending "add some examples to (or delete) #{__FILE__}"
end
