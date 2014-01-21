class AddCommPrefsAndAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :local_address, :string
    add_column :users, :perm_address, :string
    add_column :users, :committee_preferences, :string
    add_column :users, :suggestion, :text
    add_column :users, :graduation_semester, :string
  end
end
