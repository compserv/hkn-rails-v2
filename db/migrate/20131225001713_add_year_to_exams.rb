class AddYearToExams < ActiveRecord::Migration
  def change
  	add_column :exams, :year, :integer
  	add_column :exams, :semester, :string
  end
end
