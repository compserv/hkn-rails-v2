class CreateCourseSemesters < ActiveRecord::Migration
  def change
    create_table :course_semesters do |t|
      t.string :season
      t.integer :year

      t.timestamps
    end
  end
end
