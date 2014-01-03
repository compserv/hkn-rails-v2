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
  has_and_belongs_to_many :users

  class << self
    def current
      # TODO(mark): This isn't always the case, but works for now.
      last
    end
  end

  def name
    "#{season} #{year}"
  end

  def candidates
    Role.semester_filter(self).candidates.includes(:users).all_users
  end

  def officers
    Role.semester_filter(self).officers.includes(:users).all_users
  end

  def committee_members
    Role.semester_filter(self).committee_members.includes(:users).all_users
  end

  def members
    Role.members.includes(:users).all_users
  end

end
