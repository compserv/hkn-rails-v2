class AddDownloadCountToResumeBookUrl < ActiveRecord::Migration
  def change
    add_column :resume_book_urls, :download_count, :integer
  end
end
