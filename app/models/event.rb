# == Schema Information
#
# Table name: events
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  description           :string(255)
#  rsvp_count            :integer
#  created_at            :datetime
#  updated_at            :datetime
#  owner_id              :integer
#  location              :string(255)
#  start_time            :datetime
#  end_time              :datetime
#  event_type            :string(255)
#  need_transportation?  :boolean
#  view_permission_roles :string(255)
#  rsvp_permission_roles :string(255)
#

class Event < ActiveRecord::Base
  has_many :rsvps, dependent: :destroy
  has_many :users, through: :rsvps

  validates :title, presence: true, length: { maximum: 80 }
  validates :description, length: { maximum: 1000 }
  validates :event_type, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates_inclusion_of :view_permission_roles, in: [:candidates, :members, :officers, nil]

  scope :with_permission, Proc.new { |user| 
    if user.nil?
      where(:view_permission_roles => nil)
    elsif user.is_officer_for_semester? MemberSemester.current
      all
    elsif user.is_active_member?
      where(view_permission_roles: %w[candidates members nil])
    elsif user.is_candidate?
      where(view_permission_roles: %w[candidates nil])
    else
      where(:view_permission_roles => nil)
    end
  }

  VALID_SORT_FIELDS = %w[start_time name location event_type]

  def self.past
    Event.where(['start_time < ?', Time.now])
  end

  def self.upcoming
    Event.where(['start_time > ?', Time.now])
  end
end
