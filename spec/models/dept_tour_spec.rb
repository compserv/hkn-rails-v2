# == Schema Information
#
# Table name: dept_tours
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :datetime
#  email      :string(255)
#  phone      :string(255)
#  comments   :text
#  responded  :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe DeptTour do
  pending "add some examples to (or delete) #{__FILE__}"
end
