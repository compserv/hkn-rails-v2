class CreateTutorSlotPreferences < ActiveRecord::Migration
  def change
    create_table :tutor_slot_preferences do |t|
      t.integer :tutor_slot_id
      t.integer :user_id
      t.integer :preference
      t.integer :room_preference
      t.boolean :recieved

      t.timestamps
    end
  end
end
