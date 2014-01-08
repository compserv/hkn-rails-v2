# == Schema Information
#
# Table name: events
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  description           :string(255)
#  rsvp_count            :integer
#  created_at            :datetime
#  updated_at            :datetime
#  owner_id              :integer
#  location              :string(255)
#  start_time            :datetime
#  end_time              :datetime
#  event_type            :string(255)
#  need_transportation?  :boolean
#  view_permission_roles :string(255)
#  rsvp_permission_roles :string(255)
#

class Event < ActiveRecord::Base
  has_many :rsvps, dependent: :destroy
  has_many :users, through: :rsvps

  validates :title, presence: true, length: { maximum: 80 }
  validates :description, length: { maximum: 1000 }
  validates :event_type, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
end
