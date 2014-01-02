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

class TutorSlot < ActiveRecord::Base
  validates :room, inclusion: { in: %w(Cory Soda) }
  validates :day, inclusion: { in: %w(Monday Tuesday Wednesday Thursday Friday) }
  validates :duration_in_minutes, :numericality => { greater_than_or_equal_to: 15, less_than_or_equal_to: 120 }
  validates :type, inclusion: { in: %w(Officer Cmember) } # is this what type is ?
  validate :start_time_range
  has_many :tutor_slot_preferences

  def start_time_range
    unless (11..16).include?(start_time.hour)
      errors.add(:start_time, "need to be during office hours")
    end
  end


end
