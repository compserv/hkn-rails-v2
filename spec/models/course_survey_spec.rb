# == Schema Information
#
# Table name: course_surveys
#
#  id                 :integer          not null, primary key
#  course_offering_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#  status             :string(255)
#  survey_time        :datetime
#  max_surveyors      :integer
#

require 'spec_helper'

describe CourseSurvey do
  before do
    @course_survey = CourseSurvey.new(max_surveyors: 1, status: "Done", survey_time: DateTime.now,
                                      course_staff_member_id: 1, course_offering_id: 1, number_responses: 1,
                                      course_id: 1, course_semester_id: 1, staff_member_id: 1)
  end

  subject { @course_survey }
  it { should respond_to(:course_staff_member_id) }
  it { should respond_to(:course_offering_id) }
  it { should respond_to(:number_responses) }
  it { should respond_to(:status) }
  it { should respond_to(:max_surveyors) }
  it { should respond_to(:survey_time) }
  it { should be_valid }

  describe "when negative responses" do
    before { @course_survey.number_responses = -1 }
    it { should_not be_valid }
  end

  describe "when no ID" do
    before { @course_survey.course_offering_id = nil }
    it { should_not be_valid }
  end

  describe "when no instructor" do
    before { @course_survey.course_staff_member_id = nil }
    it { should_not be_valid }
  end

end
