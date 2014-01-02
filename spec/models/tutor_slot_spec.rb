# == Schema Information
#
# Table name: tutor_slots
#
#  id                  :integer          not null, primary key
#  room                :string(255)
#  day                 :string(255)
#  start_time          :time
#  duration_in_minutes :integer
#  type                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe TutorSlot do
  pending "add some examples to (or delete) #{__FILE__}"
end
