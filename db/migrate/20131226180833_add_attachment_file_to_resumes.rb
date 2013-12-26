class AddAttachmentFileToResumes < ActiveRecord::Migration
  def self.up
    change_table :resumes do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :resumes, :file
  end
end
