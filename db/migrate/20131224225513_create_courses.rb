class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :department
      t.integer :course_number
      t.string :course_prefix
      t.string :course_suffix
      t.string :name
      t.integer :units
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
