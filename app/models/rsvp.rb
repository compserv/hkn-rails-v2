# == Schema Information
#
# Table name: rsvps
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  event_id               :integer
#  created_at             :datetime
#  updated_at             :datetime
#  confirmed              :boolean
#  confirmed_by           :integer
#  confirmed_at           :datetime
#  comment                :string
#
#
class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
end
