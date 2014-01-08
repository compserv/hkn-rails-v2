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

require 'spec_helper'

describe InfosessionRequest do
  pending "add some examples to (or delete) #{__FILE__}"
end
