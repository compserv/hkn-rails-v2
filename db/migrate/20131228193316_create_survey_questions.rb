class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.integer :course_survey_id
      t.string :question_text
      t.string :keyword
      t.float :mean_score

      t.timestamps
    end

    add_index :survey_questions, :course_survey_id
  end
end
