class AddShouldResetSessionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :should_reset_session, :boolean
  end
end
