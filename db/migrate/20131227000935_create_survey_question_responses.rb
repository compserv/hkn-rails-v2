class CreateSurveyQuestionResponses < ActiveRecord::Migration
  def change
    create_table :survey_question_responses do |t|
      t.integer :survey_question_id
      t.integer :rating

      t.timestamps
    end
  end
end
