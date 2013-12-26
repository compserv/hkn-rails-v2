class CreateMemberSemestersUsers < ActiveRecord::Migration
  def change
    create_table :member_semesters_users do |t|
      t.belongs_to :member_semester
      t.belongs_to :user
    end
    add_index :member_semesters_users, :member_semester_id
    add_index :member_semesters_users, :user_id
  end
end
