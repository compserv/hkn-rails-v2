# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  resource_id   :integer
#  resource_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  role_type     :string(255)
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  scopify

  scope :all_current, -> { where(resource_id: MemberSemester.current.id) }
  scope :officers, -> { where(role_type: "officer") }
  scope :committee_members, -> { where(role_type: "committee_member") }
  scope :candidates, -> { where(role_type: "candidate") }

  class << self
    def current(position)
      find_by_name_and_resource_id(position, MemberSemester.current.id)
    end

    def position_for_semester(position, semester)
      find_by_name_and_resource_id(position, semester.id)
    end

    def all_users
      all.collect { |role| role.users }.flatten
    end

    def current_officers
      all_current.officers.all_users
    end

    def current_committee_members
      all_current.committee_members.all_users
    end

    def current_candidates
      all_current.candidates.all_users
    end
  end

  def semester
    resource
  end

  def is_officer?
    role_type == "officer"
  end

end
