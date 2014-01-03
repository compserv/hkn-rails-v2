class CreateQuizQuestions < ActiveRecord::Migration
  def change
    create_table :quiz_questions do |t|
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
