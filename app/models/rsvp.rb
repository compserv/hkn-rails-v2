# == Schema Information
#
# Table name: rsvps
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  event_id     :integer
#  confirmed    :boolean
#  confirmed_by :integer
#  confirmed_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  comment      :string(255)
#

class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :comment, length: { maximum: 300 }
end
