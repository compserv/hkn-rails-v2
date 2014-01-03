class CreateMobileCarriers < ActiveRecord::Migration
  def change
    create_table :mobile_carriers do |t|
      t.string :name
      t.string :sms_email

      t.timestamps
    end
  end
end
