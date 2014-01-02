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

class TutorSlotPreference < ActiveRecord::Base
  belongs_to :tutor_slot
  belongs_to :user
  validates_presence_of :tutor_slot, :user, :preference, :room_preference
end
