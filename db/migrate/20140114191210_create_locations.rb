class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.integer :capacity
      t.text :comments

      t.timestamps
    end
  end
end
