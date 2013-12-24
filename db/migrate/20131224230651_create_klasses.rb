class CreateKlasses < ActiveRecord::Migration
  def change
    create_table :klasses do |t|
      t.integer :course_id
      t.integer :course_semester_id
      t.string :location
      t.string :time

      t.timestamps
    end
    add_index :klasses, [:course_id, :course_semester_id]
  end
end
