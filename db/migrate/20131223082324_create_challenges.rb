class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :requester_id
      t.integer :candidate_id
      t.boolean :confirmed
      t.boolean :rejected
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
