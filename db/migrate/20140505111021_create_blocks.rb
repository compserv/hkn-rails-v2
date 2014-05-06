class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :rsvp_cap
      t.datetime :start_time
      t.datetime :end_time
      t.references :event, index: true

      t.timestamps
    end
  end
end
