class AddCourseIdIndexToExams < ActiveRecord::Migration
  def change
    add_index :exams, :course_id
  end
end
