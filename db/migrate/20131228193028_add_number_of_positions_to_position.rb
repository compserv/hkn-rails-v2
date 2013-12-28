class AddNumberOfPositionsToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :number_of_position, :integer
  end
end
