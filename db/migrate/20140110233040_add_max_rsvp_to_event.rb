class AddMaxRsvpToEvent < ActiveRecord::Migration
  def change
    add_column :events, :max_rsvps, :integer
  end
end
