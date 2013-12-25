# == Schema Information
#
# Table name: challenges
#
#  id           :integer          not null, primary key
#  requester_id :integer
#  candidate_id :integer
#  confirmed    :boolean
#  rejected     :boolean
#  name         :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#

class Challenge < ActiveRecord::Base
  validates :name, presence: true
  validates :requester_id, presence: true
  #validates :candidate_id, presence: true
end
