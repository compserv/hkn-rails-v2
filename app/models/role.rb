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
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  scopify

  class << self
    def current(position)
      find_by_name_and_resource_id(position, MemberSemester.current.id)
    end

    def position_for_semester(position, semester)
      find_by_name_and_resource_id(position, semester.id)
    end
  end

  def semester
    resource
  end

  def is_officer?
    role_type == "officer"
  end

end
