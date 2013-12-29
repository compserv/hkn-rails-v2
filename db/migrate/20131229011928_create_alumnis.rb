class CreateAlumnis < ActiveRecord::Migration
  def change
    create_table :alumnis do |t|
      t.string :grad_semester
      t.string :grad_school
      t.string :job_title
      t.string :company
      t.integer :salary
      t.integer :user_id
      t.string :perm_email
      t.string :location
      t.text :suggestions
      t.boolean :mailing_list

      t.timestamps
    end
  end
end
