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
  validate :valid_date?

  def valid_date?
    unless (10..17).include?(date.hour)
      errors[:base] << "Date must be between 10 (10am) and 18 (6pm)"
    end
    unless date.future?
      errors[:base] << "Date must be in the future"
    end
    unless (1..5).include?(date.wday)
      errors[:base] << "Date must be on a weekday"
    end
  end
end
