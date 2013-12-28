# == Schema Information
#
# Table name: position_users
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  position_id      :integer
#  nominated        :boolean
#  elected          :boolean
#  sid              :integer
#  keycard          :integer
#  midnight_meeting :boolean
#  txt              :boolean
#  elected_time     :datetime
#  non_hkn_email    :string(255)
#  desired_username :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe PositionUser do
  pending "add some examples to (or delete) #{__FILE__}"
end
