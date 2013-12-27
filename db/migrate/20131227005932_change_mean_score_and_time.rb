class ChangeMeanScoreAndTime < ActiveRecord::Migration
  def change
    change_column :survey_questions, :mean_score, :float
    remove_column :course_surveys, :time
    add_column :course_surveys, :survey_time, :datetime
  end
end
