# == Schema Information
#
# Table name: dept_tours
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :datetime
#  email      :string(255)
#  phone      :string(255)
#  submitted  :datetime
#  comments   :text
#  responded  :boolean
#  created_at :datetime
#  updated_at :datetime
#

class DeptTour < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :date
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_inclusion_of :responded, :in =>[true,false]
  validates_presence_of :submitted
end
