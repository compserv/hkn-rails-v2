class AddAttachmentFileToExams < ActiveRecord::Migration
  def self.up
    change_table :exams do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :exams, :file
  end
end
