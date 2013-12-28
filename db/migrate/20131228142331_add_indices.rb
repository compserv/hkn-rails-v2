class AddIndices < ActiveRecord::Migration
  def change
    add_index :elections, :member_semester_id
    add_index :position_users, :user_id
    add_index :position_users, :position_id
    add_index :positions, :election_id
  end
end
