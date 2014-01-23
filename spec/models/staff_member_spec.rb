# == Schema Information
#
# Table name: staff_members
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  release_surveys :boolean
#  created_at      :datetime
#  updated_at      :datetime
#  picture         :string(255)
#  title           :string(255)
#  interests       :text
#  home_page       :string(255)
#  office          :string(255)
#  phone_number    :string(255)
#  email           :string(255)
#

require 'spec_helper'

describe StaffMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
