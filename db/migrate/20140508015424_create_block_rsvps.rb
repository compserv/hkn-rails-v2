class CreateBlockRsvps < ActiveRecord::Migration
  def change
    create_table :block_rsvps do |t|
      t.references :block, index: true
      t.references :rsvp, index: true

      t.timestamps
    end
  end
end
