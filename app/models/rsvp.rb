# == Schema Information
#
# Table name: rsvps
#
#  id                     :integer          not null, primary key
#
#  # Do we still need these if it belongs_to?
#  user_id                :integer
#  event_id               :integer
#
#  created_at             :datetime
#  updated_at             :datetime
#  confirmed              :boolean
#  confirmed_by           :integer
#  confirmed_at           :datetime
#  comment                :string
#
#
class Rsvp < ActiveRecord::Base
  has_and_belongs_to :event, :user
end
