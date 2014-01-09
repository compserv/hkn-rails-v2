class AddIndexes < ActiveRecord::Migration
  def change
    add_index :alumni, :user_id
    add_index :users, :mobile_carrier_id
    add_index :tutor_slot_preferences, :user_id
    add_index :tutor_slot_preferences, :tutor_slot_id
  end
end
