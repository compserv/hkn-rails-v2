class AddCourseGuideAndNameToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_guide, :text
    add_column :courses, :name, :string
  end
end
