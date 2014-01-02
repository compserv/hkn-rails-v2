class CreateCandidateQuizzes < ActiveRecord::Migration
  def change
    create_table :candidate_quizzes do |t|
      t.integer :user_id
      t.integer :score

      t.timestamps
    end
  end
end
