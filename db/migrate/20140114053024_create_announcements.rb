class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.string :body
      t.integer :user_id

      t.timestamps
    end
  end
end
