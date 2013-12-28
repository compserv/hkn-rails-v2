class AddElectionToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :election_id, :integer
  end
end
