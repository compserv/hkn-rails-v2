class CreatePositionUsers < ActiveRecord::Migration
  def change
    create_table :position_users do |t|
      t.integer :user_id
      t.integer :position_id
      t.boolean :nominated
      t.boolean :elected
      t.integer :sid
      t.integer :keycard
      t.boolean :midnight_meeting
      t.boolean :txt
      t.datetime :elected_time
      t.string :non_hkn_email
      t.string :desired_username

      t.timestamps
    end
  end
end
