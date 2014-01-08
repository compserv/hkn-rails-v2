# == Schema Information
#
# Table name: infosession_requests
#
#  id           :integer          not null, primary key
#  company_name :string(255)
#  address1     :string(255)
#  address2     :string(255)
#  city         :string(255)
#  state        :string(255)
#  zip_code     :string(255)
#  name         :string(255)
#  title        :string(255)
#  phone        :string(255)
#  email        :string(255)
#  alt_name     :string(255)
#  alt_title    :string(255)
#  alt_phone    :string(255)
#  alt_email    :string(255)
#  pref_date    :text
#  pref_food    :text
#  pref_ad      :text
#  comments     :text
#  created_at   :datetime
#  updated_at   :datetime
#

class InfosessionRequest < ActiveRecord::Base

  validates_presence_of :company_name, :address1, :city, :state, :zip_code, :name, :phone, :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :phone, with: /\A(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?\z/

end
