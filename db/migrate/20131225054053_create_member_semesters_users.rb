class CreateMemberSemestersUsers < ActiveRecord::Migration
  def change
    create_table :member_semesters_users do |t|
      t.belongs_to :member_semester
      t.belongs_to :user
    end
    add_index :member_semesters_users, :member_semester_id, unique: true
    add_index :member_semesters_users, :user_id, unique: true
  end
end
