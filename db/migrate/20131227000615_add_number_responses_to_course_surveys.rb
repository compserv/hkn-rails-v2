class AddNumberResponsesToCourseSurveys < ActiveRecord::Migration
  def change
    add_column :course_surveys, :number_responses, :integer
  end
end
