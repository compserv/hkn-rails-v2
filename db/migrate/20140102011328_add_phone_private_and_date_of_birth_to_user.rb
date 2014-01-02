class AddPhonePrivateAndDateOfBirthToUser < ActiveRecord::Migration
  def change
    add_column :users, :private, :boolean
    add_column :users, :date_of_birth, :date
    add_column :users, :phone_number, :string
    add_column :users, :sms_alerts, :boolean
  end
end
