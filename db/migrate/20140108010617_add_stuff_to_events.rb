class AddStuffToEvents < ActiveRecord::Migration
  def change
    add_column :events, :location, :string
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
    add_column :events, :event_type, :string
    add_column :events, :need_transportation?, :boolean
    add_column :events, :view_permission_roles, :string
    add_column :events, :rsvp_permission_roles, :string
    add_column :rsvps, :transportation_ability, :integer
    add_index :rsvps, :user_id
    add_index :rsvps, :event_id
  end
end
