class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.integer :member_semester_id

      t.timestamps
    end
  end
end
