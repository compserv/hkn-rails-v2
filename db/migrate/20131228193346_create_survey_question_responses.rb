class CreateSurveyQuestionResponses < ActiveRecord::Migration
  def change
    create_table :survey_question_responses do |t|
      t.integer :survey_question_id
      t.integer :rating

      t.timestamps
    end

    add_index :survey_question_responses, :survey_question_id
  end
end
