class AddStuffToStaffMember < ActiveRecord::Migration
  def change
    add_column :staff_members, :picture, :string
    add_column :staff_members, :title, :string
    add_column :staff_members, :interests, :text
    add_column :staff_members, :home_page, :string
    add_column :staff_members, :office, :string
    add_column :staff_members, :phone_number, :string
    add_column :staff_members, :email, :string
  end
end
