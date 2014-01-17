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
  SEASONS = ['Fall', 'Spring']
  validates :season, inclusion: { in: SEASONS,
      message: "%{value} is not a valid semester" }

  class << self
    def current
      # TODO(mark): This isn't always the case, but works for now.
      last
    end

    def years
      pluck(:year).uniq
    end
  end

  def name
    "#{season} #{year}"
  end

  def candidates
    Role.semester_filter(self).candidates.all_users
  end

  def officers
    Role.semester_filter(self).officers.all_users
  end

  def committee_members
    Role.semester_filter(self).committee_members.all_users
  end

  def next
    if season == "Fall"
      MemberSemester.find_by_year_and_season(year + 1, "Spring")
    else
      MemberSemester.find_by_year_and_season(year, "Fall")
    end
  end

  def prev
    if season == "Spring"
      MemberSemester.find_by_year_and_season(year - 1, "Fall")
    else
      MemberSemester.find_by_year_and_season(year, "Spring")
    end
  end

  def start_time
    if season == "Spring"
      Date.civil(year)
    else
      Date.civil(year, 8)
    end
  end

  def end_time
    if season == "Spring"
      Date.civil(year, 6)
    else
      Date.civil(year, 12, 30)
    end
  end
end
