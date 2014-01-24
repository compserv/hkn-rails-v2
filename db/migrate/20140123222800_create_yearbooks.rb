class CreateYearbooks < ActiveRecord::Migration
  def change
    create_table :yearbooks do |t|
      t.integer :year

      t.timestamps
    end
  end
end
