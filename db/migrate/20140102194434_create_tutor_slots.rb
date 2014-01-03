class CreateTutorSlots < ActiveRecord::Migration
  def change
    create_table :tutor_slots do |t|
      t.string :room
      t.string :day
      t.time :start_time
      t.integer :duration_in_minutes
      t.string :type

      t.timestamps
    end
  end
end
