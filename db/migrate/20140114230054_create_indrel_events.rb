class CreateIndrelEvents < ActiveRecord::Migration
  def change
    create_table :indrel_events do |t|
      t.datetime :time
      t.integer :location_id
      t.integer :indrel_event_type_id
      t.text :food
      t.text :prizes
      t.integer :turnout
      t.integer :company_id
      t.integer :contact_id
      t.string :officer
      t.text :feedback
      t.text :comments

      t.timestamps
    end
  end
end
