class CreateIndrelEventTypes < ActiveRecord::Migration
  def change
    create_table :indrel_event_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
