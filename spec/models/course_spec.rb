# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  department  :string(255)
#  course_name :string(255)
#  units       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Course do
  pending "add some examples to (or delete) #{__FILE__}"
end