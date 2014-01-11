class AddAttachmentIsoToResumeBooks < ActiveRecord::Migration
  def self.up
    change_table :resume_books do |t|
      t.attachment :iso
    end
  end

  def self.down
    drop_attached_file :resume_books, :iso
  end
end
