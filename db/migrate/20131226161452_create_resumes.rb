class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.decimal :overall_gpa
      t.decimal :major_gpa
      t.text :resume_text
      t.integer :graduation_year
      t.string :graduation_semester
      t.integer :user_id
      t.boolean :included

      t.timestamps
    end
  end
end
