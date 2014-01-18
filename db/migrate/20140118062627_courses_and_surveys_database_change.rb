class CoursesAndSurveysDatabaseChange < ActiveRecord::Migration
  def change
    remove_column :course_offerings, :coursesurveys_active, :boolean

    create_table(:surveyors_candidates, :id => false) do |t|
      t.belongs_to :course_survey
      t.belongs_to :user
    end

    add_index :surveyors_candidates, ["course_survey_id", "user_id"]

    remove_column :course_surveys, :staff_member_id, :integer
    remove_column :course_surveys, :course_staff_member_id, :integer
    remove_column :course_surveys, :course_id, :integer
    remove_column :course_surveys, :course_semester_id, :integer
    remove_column :course_surveys, :number_responses, :integer

    remove_column :course_staff_members, :course_id, :integer
    remove_column :course_staff_members, :course_semester_id, :integer

    remove_column :survey_questions, :course_survey_id, :integer

    add_column :survey_question_responses, :number_responses, :integer
  end
end
