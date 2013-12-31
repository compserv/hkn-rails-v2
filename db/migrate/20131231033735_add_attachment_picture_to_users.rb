class AddAttachmentPictureToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :picture
    change_table :users do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :users, :picture
  end
end
