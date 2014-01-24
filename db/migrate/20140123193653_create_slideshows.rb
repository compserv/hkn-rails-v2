class CreateSlideshows < ActiveRecord::Migration
  def change
    create_table :slideshows do |t|
      t.integer :member_semester_id

      t.timestamps
    end
  end
end
