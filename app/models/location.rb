# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  capacity   :integer
#  comments   :text
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
  validates_presence_of :name, :capacity
end
