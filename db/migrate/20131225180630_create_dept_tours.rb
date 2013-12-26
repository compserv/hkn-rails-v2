class CreateDeptTours < ActiveRecord::Migration
  def change
    create_table :dept_tours do |t|
      t.string :name
      t.datetime :date
      t.string :email
      t.string :phone
      t.datetime :submitted
      t.text :comments
      t.boolean :responded

      t.timestamps
    end
  end
end
