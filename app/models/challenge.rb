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
  validates :candidate_id, presence: true

  def candidate_name
    User.where(id: candidate_id).first.full_name
  end

  def url
    Rails.application.routes.url_helpers.challenges_path
  end

  def desc
    self.candidate_name + " has requested a challenge from you"
  end

  def image
    "icons/notifications/challenge.jpg"
  end

  def officer
    User.where(id: requester_id).first
  end

end
