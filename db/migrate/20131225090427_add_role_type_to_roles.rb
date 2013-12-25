class AddRoleTypeToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :role_type, :string
  end
end
