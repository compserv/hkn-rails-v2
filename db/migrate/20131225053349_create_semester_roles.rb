class CreateSemesterRoles < ActiveRecord::Migration
  def change
    create_table :semester_roles do |t|
      t.references :member_semester
      t.references :role

      t.timestamps
    end
    add_index :semester_roles, :member_semester_id, unique: true
    add_index :semester_roles, :role_id, unique: true
  end
end
