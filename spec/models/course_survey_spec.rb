# == Schema Information
#
# Table name: course_surveys
#
#  id                 :integer          not null, primary key
#  max_surveyors      :integer
#  status             :string(255)
#  time               :string(255)
#  staff_id           :integer
#  course_offering_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#  number_responses   :integer
#

require 'spec_helper'

describe CourseSurvey do
  before do
    @course_survey = CourseSurvey.new(max_surveyors: 1, status: "Done", time: "Tuesday 3:40", staff_id: 1,
                                      course_offering_id: 1, number_responses: 1)
  end

  subject { @course_survey }
  it { should respond_to(:max_surveyors) }
  it { should respond_to(:status) }
  it { should respond_to(:time) }
  it { should respond_to(:staff_id) }
  it { should respond_to(:course_offering_id) }
  it { should respond_to(:number_responses) }
  it { should be_valid }

  describe "when negative responses" do
    before { @course_survey.number_responses = -1 }
    it { should_not be_valid }
  end

  describe "when no ID" do
    before { @course_survey.course_offering_id = nil }
    it { should_not be_valid }
  end

end
