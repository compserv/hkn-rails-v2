class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.integer :course_survey_id
      t.string :question_text
      t.string :keyword
      t.integer :mean_score

      t.timestamps
    end
  end
end
