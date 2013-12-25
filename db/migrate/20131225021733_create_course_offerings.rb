class CreateCourseOfferings < ActiveRecord::Migration
  def change
    create_table :course_offerings do |t|
      t.integer :course_id
      t.integer :course_semester_id
      t.integer :lecture_number

      t.timestamps
    end
    add_index :course_offerings, [:course_id, :course_semester_id]
  end
end
