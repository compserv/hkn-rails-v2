class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :events, :need_transportation?, :need_transportation
  end
end
