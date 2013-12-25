class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :course_id
      t.string :exam_type
      t.integer :number
      t.boolean :is_solution

      t.timestamps
    end
  end
end
