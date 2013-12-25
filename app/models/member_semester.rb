# == Schema Information
#
# Table name: member_semesters
#
#  id         :integer          not null, primary key
#  year       :integer
#  season     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MemberSemester < ActiveRecord::Base
end
