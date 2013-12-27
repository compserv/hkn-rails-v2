class CreateCourseSurveys < ActiveRecord::Migration
  def change
    create_table :course_surveys do |t|
      t.integer :staff_member_id
      t.integer :course_staff_member_id
      t.integer :course_offering_id
      t.integer :course_id
      t.integer :course_semester_id

      t.timestamps
    end
    add_index :course_surveys, [:staff_member_id, :course_id]
    add_index :course_surveys, :course_id
    add_index :course_surveys, :staff_member_id
    add_index :course_surveys, [:staff_member_id, :course_semester_id]
  end
end
