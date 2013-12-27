class AdddingIndexingToSurveys < ActiveRecord::Migration
  def change
    add_index :course_surveys, :course_offering_id
    add_index :survey_question_responses, :survey_question_id
    add_index :survey_questions, :course_survey_id
  end
end
