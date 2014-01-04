class InfosessionRequest < ActiveRecord::Base

  validates_presence_of :company_name, :address1, :city, :state, :zip_code, :name, :phone, :email
end
