class AddCourseSurveyActiveToMemberSemester < ActiveRecord::Migration
  def change
    add_column :member_semesters, :coursesurveys_active, :boolean
    add_column :course_offerings, :coursesurveys_active, :boolean
  end
end
