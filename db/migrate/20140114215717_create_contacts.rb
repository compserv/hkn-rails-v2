class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.integer :company_id
      t.text :comments
      t.string :cellphone

      t.timestamps
    end
  end
end
