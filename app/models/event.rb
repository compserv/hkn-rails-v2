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
#  created_by             :integer
#

class Event < ActiveRecord::Base
  has_many :roles # Is this a good way to store permissions?
  has_and_belongs_to_many :rsvps
end
