class AddTransactionidToResumeBookUrl < ActiveRecord::Migration
  def change
    add_column :resume_book_urls, :transaction_id, :string
  end
end
