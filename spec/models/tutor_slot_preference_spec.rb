# == Schema Information
#
# Table name: tutor_slot_preferences
#
#  id              :integer          not null, primary key
#  tutor_slot_id   :integer
#  user_id         :integer
#  preference      :integer
#  room_preference :integer
#  recieved        :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe TutorSlotPreference do
  pending "add some examples to (or delete) #{__FILE__}"
end
