class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.integer :user_id
      t.integer :event_id
      t.boolean :confirmed
      t.integer :confirmed_by
      t.datetime :confirmed_at
      t.datetime :created_at
      t.datetime :updated_at
      t.string :comment

      t.timestamps
    end
    add_index :rsvps, [:user_id, :event_id]
  end
end
