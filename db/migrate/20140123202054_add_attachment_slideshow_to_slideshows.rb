class AddAttachmentSlideshowToSlideshows < ActiveRecord::Migration
  def self.up
    change_table :slideshows do |t|
      t.attachment :slideshow
    end
  end

  def self.down
    drop_attached_file :slideshows, :slideshow
  end
end
