# == Schema Information
#
# Table name: mobile_carriers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  sms_email  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MobileCarrier < ActiveRecord::Base
end
