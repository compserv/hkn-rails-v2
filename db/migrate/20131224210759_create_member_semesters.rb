class CreateMemberSemesters < ActiveRecord::Migration
  def change
    create_table :member_semesters do |t|
      t.integer :year
      t.string :season

      t.timestamps
    end
  end
end
