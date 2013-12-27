class CreateCourseSurveys < ActiveRecord::Migration
  def change
    create_table :course_surveys do |t|
      t.integer :max_surveyors
      t.string :status
      t.string :time
      t.integer :staff_id
      t.integer :course_offering_id

      t.timestamps
    end
  end
end
