class AddAttachmentPdfToYearbooks < ActiveRecord::Migration
  def self.up
    change_table :yearbooks do |t|
      t.attachment :pdf
    end
  end

  def self.down
    drop_attached_file :yearbooks, :pdf
  end
end
