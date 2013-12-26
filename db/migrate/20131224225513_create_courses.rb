class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :department
      t.string :course_name
      t.integer :units
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
