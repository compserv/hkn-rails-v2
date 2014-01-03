class AddCandidateQuizIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :candidate_quiz_id, :integer
    add_index :users, :candidate_quiz_id
  end
end
