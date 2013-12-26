class CreateCourseStaffMembers < ActiveRecord::Migration
  def change
    create_table :course_staff_members do |t|
      t.integer :course_offering_id
      t.integer :staff_member_id
      t.string :staff_role

      t.timestamps
    end
    add_index :course_staff_members, [:course_offering_id, :staff_member_id],
              :name => "index_course_staff_on_course_offering_and_staff_member_ids"
  end
end
