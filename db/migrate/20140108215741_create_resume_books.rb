class CreateResumeBooks < ActiveRecord::Migration
  def change
    create_table :resume_books do |t|
      t.string :title
      t.string :remarks
      t.text :details
      t.date :cutoff_date

      t.timestamps
    end
  end
end
