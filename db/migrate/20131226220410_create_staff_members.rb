class CreateStaffMembers < ActiveRecord::Migration
  def change
    create_table :staff_members do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :release_surveys

      t.timestamps
    end
  end
end
