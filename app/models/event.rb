# == Schema Information
#
# Table name: events
#
#  id                     :integer          not null, primary key
#  title                  :string
#  description            :string
#  rsvp_count             :integer
#  created_at             :datetime
#  updated_at             :datetime
#  owner_id               :integer
#

class Event < ActiveRecord::Base
  has_many :rsvps
  has_many :users, through: :rsvps
end