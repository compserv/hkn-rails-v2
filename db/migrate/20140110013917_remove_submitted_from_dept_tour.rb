class RemoveSubmittedFromDeptTour < ActiveRecord::Migration
  def change
    remove_column :dept_tours, :submitted, :datetime
  end
end
