class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.integer :rsvp_count
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :created_by

      t.timestamps
    end
  end
end
