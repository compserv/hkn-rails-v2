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

class PositionUser < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :position_id
  validates_uniqueness_of :user_id, :scope => [:position_id, :semester]
  validates :keycard, :numericality => {
    :greater_than_or_equal_to => 10000,
    :less_than_or_equal_to    => 999999,
    :message                  => "must be a 5- or 6-digit number",
    :allow_nil                => true
  }
  validates :sid, :numericality => { :allow_nil => true }

end
