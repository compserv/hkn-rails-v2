class AddColumnsToResumeBookUrl < ActiveRecord::Migration
  def change
    add_column :resume_book_urls, :company, :string
    add_column :resume_book_urls, :name, :string
    add_column :resume_book_urls, :email, :string
  end
end
