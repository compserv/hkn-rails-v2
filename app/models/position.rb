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

class Position < ActiveRecord::Base
  belongs_to :election
  has_many :position_users
  validates_presence_of :name
end
