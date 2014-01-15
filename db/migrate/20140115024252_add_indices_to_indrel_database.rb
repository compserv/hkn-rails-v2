class AddIndicesToIndrelDatabase < ActiveRecord::Migration
  def change
    add_index :announcements, :user_id
    add_index :contacts, :company_id
    add_index :indrel_events, :location_id
    add_index :indrel_events, :indrel_event_type_id
    add_index :indrel_events, :company_id
    add_index :indrel_events, :contact_id
    add_index :resume_book_urls, :resume_book_id
  end
end
