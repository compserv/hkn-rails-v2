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

require 'spec_helper'

describe Challenge do
  pending "add some examples to (or delete) #{__FILE__}"
end
