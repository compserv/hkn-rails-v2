# == Schema Information
#
# Table name: positions
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  election_id        :integer
#  number_of_position :integer
#

require 'spec_helper'

describe Position do
  pending "add some examples to (or delete) #{__FILE__}"
end
