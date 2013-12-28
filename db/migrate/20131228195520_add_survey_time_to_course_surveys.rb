class AddSurveyTimeToCourseSurveys < ActiveRecord::Migration
  def change
    add_column :course_surveys, :survey_time, :datetime
    add_column :course_surveys, :status, :string
    add_column :course_surveys, :max_surveyors, :integer
    add_column :course_surveys, :number_responses, :integer
  end
end
