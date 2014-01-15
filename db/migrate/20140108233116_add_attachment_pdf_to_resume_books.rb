class AddAttachmentPdfToResumeBooks < ActiveRecord::Migration
  def self.up
    change_table :resume_books do |t|
      t.attachment :pdf
    end
  end

  def self.down
    drop_attached_file :resume_books, :pdf
  end
end
