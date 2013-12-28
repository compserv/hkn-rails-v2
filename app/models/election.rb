# == Schema Information
#
# Table name: elections
#
#  id                 :integer          not null, primary key
#  member_semester_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Election < ActiveRecord::Base
  belongs_to :member_semester
  has_many :positions
end
