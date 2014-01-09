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
  @Committees = %w(pres vp rsec treas csec deprel act alumrel bridge compserv indrel serv studrel tutoring pub examfiles ejc) #This generates a constant which is an array of possible committees.
  Positions = %w(officer committee_member candidate)  # A list of possible positions
  Execs = %w(pres vp rsec csec treas deprel) # Executive positions
  NonExecs = @Committees-Execs

  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  scopify

  scope :all_current, -> { where(resource_id: MemberSemester.current.id) }
  scope :officers, -> { where(role_type: "officer") }
  scope :committee_members, -> { where(role_type: "committee_member") }
  scope :candidates, -> { where(role_type: "candidate") }
  scope :members, -> { where(role_type: ["committee_member", "officer"])}
  scope :position, lambda {|pos| where(name: pos)}
  scope :semester_filter, lambda {|sem| where(resource_id: sem.id)}

  class << self
    def current(position)
      find_by_name_and_resource_id(position, MemberSemester.current.id)
    end

    def position_for_semester(position, semester)
      find_by_name_and_resource_id(position, semester.id)
    end

    #returns array of users
    def all_users
      all.includes(:users).collect { |role| role.users }.flatten
    end

    def current_officers_from_committee(committee)
      officers_from_committee committee, MemberSemester.current
    end

    def officers_from_committee(committee, semester)
      position(committee).officers.semester_filter(semester).all_users
    end

    def current_officers
      all_current.officers.all_users
    end

    #returns array of users
    def current_committee_members
      all_current.committee_members.all_users
    end

    #returns array of users
    def current_candidates
      all_current.candidates.all_users
    end

    def committees
      return @Committees
    end
  end

  def exec?
    Execs.include? self.name
  end

  def semester
    resource
  end

  def is_officer?
    role_type == "officer"
  end

  def nice_semester
    MemberSemester.find_by_id(resource_id).name
  end

  def nice_position
    if Execs.include? name
      nice_committee
    else
      nice_committee + " " + nice_title
    end
  end

  def nice_title
    role_type.split("_").map{|w| w.capitalize }.join(" ")
  end

  def nice_committee
    nice_committees = {
      "pres"     => "President",
      "vp"       => "Vice President",
      "rsec"     => "Recording Secretary",
      "csec"     => "Corresponding Secretary",
      "treas"    => "Treasurer",
      "deprel"   => "Department Relations",
      "act"      => "Activities",
      "alumrel"  => "Alumni Relations",
      "bridge"   => "Bridge",
      "compserv" => "Computing Services",
      "indrel"   => "Industrial Relations",
      "serv"     => "Service",
      "studrel"  => "Student Relations",
      "tutoring" => "Tutoring",
      "pub"      => "Publicity",
      "examfiles"=> "Exam Files",
      "candidate"=> ""
    }
    nice_committees[name]
  end
end
