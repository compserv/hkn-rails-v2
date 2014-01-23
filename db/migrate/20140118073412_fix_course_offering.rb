class FixCourseOffering < ActiveRecord::Migration
  def change
    add_column :course_offerings, :section, :string
    add_column :course_offerings, :time, :string
    add_column :course_offerings, :location, :string
    add_column :course_offerings, :num_students, :integer
    add_column :course_offerings, :notes, :text
  end
end
