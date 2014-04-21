class AddMaxToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :max, :integer
  end
end
