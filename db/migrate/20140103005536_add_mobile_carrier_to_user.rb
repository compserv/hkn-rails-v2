class AddMobileCarrierToUser < ActiveRecord::Migration
  def change
    add_column :users, :mobile_carrier_id, :integer
  end
end
