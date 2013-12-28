class AddingIndicesToSurveyAndStaff < ActiveRecord::Migration
  def change
    add_index :course_staff_members, :course_semester_id
    add_index :course_staff_members, :course_id
    add_index :course_surveys, :course_staff_member_id
    add_index :course_surveys, :course_offering_id
    add_index :resumes, :user_id
  end
end
