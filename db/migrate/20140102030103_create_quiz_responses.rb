class CreateQuizResponses < ActiveRecord::Migration
  def change
    create_table :quiz_responses do |t|
      t.integer :quiz_question_id
      t.integer :candidate_quiz_id
      t.string :response

      t.timestamps
    end

    add_index :quiz_responses, :candidate_quiz_id
    add_index :quiz_responses, :quiz_question_id
  end
end
