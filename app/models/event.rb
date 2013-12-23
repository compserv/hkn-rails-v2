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
#
#  # should this be called owner?
#  created_by             :integer
#
#  Also need to set up permissions somehow, based on role
#

class Event < ActiveRecord::Base
  has_many :rsvps
end
