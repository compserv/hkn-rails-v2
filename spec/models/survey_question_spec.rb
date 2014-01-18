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
#

require 'spec_helper'

describe SurveyQuestion do
  before do
    @question = SurveyQuestion.new(question_text:"Rate the overall teaching effectiveness of this instructor",
                                   keyword: "prof_eff", mean_score: 5.6, course_survey_id: 1)
  end

  subject { @question }

  it { should respond_to(:question_text) }
  it { should respond_to(:keyword) }
  it { should respond_to(:mean_score) }
  it { should respond_to(:course_survey_id) }
  it { should be_valid }

  #TODO: Make sure keywords are within a certain set, yet TBD.
end
