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

require 'spec_helper'

describe SurveyQuestionResponse do
  before do
    @response = SurveyQuestionResponse.new(survey_question_id:1, rating: 4)
  end

  subject { @response }

  it { should respond_to(:rating) }
  it { should respond_to(:survey_question_id) }
  it { should be_valid }

  describe "invalid rating" do
    before { @response.rating = 8 }
    it { should_not be_valid }
  end

end
