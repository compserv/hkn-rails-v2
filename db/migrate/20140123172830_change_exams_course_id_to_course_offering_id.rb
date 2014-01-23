class ChangeExamsCourseIdToCourseOfferingId < ActiveRecord::Migration
  def change
    rename_column :exams, :course_id, :course_offering_id
  end
end
