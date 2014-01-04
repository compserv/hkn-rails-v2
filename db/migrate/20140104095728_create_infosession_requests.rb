class CreateInfosessionRequests < ActiveRecord::Migration
  def change
    create_table :infosession_requests do |t|
      t.string :company_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip_code

      t.string :name
      t.string :title
      t.string :phone
      t.string :email

      t.string :alt_name
      t.string :alt_title
      t.string :alt_phone
      t.string :alt_email

      t.text :pref_date
      t.text :pref_food
      t.text :pref_ad
      t.text :comments

      t.timestamps
    end
  end
end
