# == Schema Information
#
# Table name: events
#
#  id                     :integer       not null, primary key
#  requester_id           :integer       not null
#  candidate_id           :integer       not null
#  confirmed              :boolean
#  rejected               :boolean
#  name                   :string        not null
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

class Challenge < ActiveRecord::Base
  validates :name, presence: true
  validates :requester_id, presence: true
  validates :candidate_id, presence: true
end
