class AddExamsCountToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :exams_count, :integer, default: 0

    Course.reset_column_information
    Course.all.each do |c|
      c.update_attribute :exams_count, c.exams.length
    end
  end
end
