class CreateResumeBookUrls < ActiveRecord::Migration
  def change
    create_table :resume_book_urls do |t|
      t.integer :resume_book_id
      t.datetime :expiration_date
      t.text :feedback
      t.string :password

      t.timestamps
    end
  end
end
