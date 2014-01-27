class AddCourseStaffMemberIdToSurveyQuestionResponses < ActiveRecord::Migration
  def change
    add_column :survey_question_responses, :course_staff_member_id, :integer
  end
end
