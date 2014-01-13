class ChangeConfirmedFormatInRsvp < ActiveRecord::Migration
  def change
    change_column :rsvps, :confirmed, :string
  end
end
