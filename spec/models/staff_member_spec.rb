# == Schema Information
#
# Table name: staff_members
#
#  id                 :integer          not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  release_ta_surveys :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe StaffMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
