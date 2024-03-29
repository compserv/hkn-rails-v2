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
#  need_transportation   :boolean
#  view_permission_roles :string(255)
#  rsvp_permission_roles :string(255)
#  max_rsvps             :integer
#

class Event < ActiveRecord::Base
  EVENT_TYPES = ["Big Fun", "Fun", "Industry", "Mandatory for Candidates", "Miscellaneous", "Service", "Exam", "Review Session"]
  PERMISSION_OPTIONS = [["Candidates and Members", "candidates"], ["Officers and Committee Members", "committee_members"], ["Officers", "officers"], ["Members", 'members'], ["Everyone", nil]]
  has_many :rsvps, dependent: :destroy
  has_many :users, through: :rsvps

  validates :title, presence: true, length: { maximum: 80 }
  validates :description, length: { maximum: 1000 }
  validates :event_type, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :max_rsvps, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_inclusion_of :rsvp_permission_roles, in: PERMISSION_OPTIONS.collect(&:last)
  validates_inclusion_of :view_permission_roles, in: PERMISSION_OPTIONS.collect(&:last)
  validates_inclusion_of :event_type, in: EVENT_TYPES

  scope :with_permission, Proc.new { |user|
    if user.nil?
      where(:view_permission_roles => nil)
    elsif user.is_officer_for_semester? MemberSemester.current
      all
    elsif user.is_active_member?
      where(view_permission_roles: %w[candidates members committee_members nil])
    elsif user.is_member?
      where(view_permission_roles: %w[candidates members nil])
    elsif user.is_currently_candidate?
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

  def self.current
    #Events within 4 months
    Event.where(start_time: (DateTime.now.ago(4.months)..DateTime.now.in(1.months)))
  end

  def short_start_time
    ampm = (start_time.hour >= 12) ? "p" : "a"
    min = (start_time.min > 0) ? start_time.strftime('%M') : ""
    hour = start_time.hour
    if hour > 12
      hour -= 12
    elsif hour == 0
      hour = 12
    end
    "#{hour}#{min}#{ampm}"
  end

  def css_event_type
    event_type.gsub(/\s/, '-').downcase
  end

  def start_date
    start_time.strftime('%Y %m/%d')
  end

  def nice_time_range(year = false)
    date_format = year ? '%a %m/%d/%y' : '%a %m/%d'
    time_format = '%I:%M%p'
    start_format = "#{date_format} #{time_format}"
    if start_time.to_date == end_time.to_date
      end_format = time_format
    else
      end_format = "#{date_format} #{time_format}"
    end
    "#{start_time.strftime(start_format)} - #{end_time.strftime(end_format)}"
  end

  def can_view? user
    Event.current.with_permission(user).include? self
  end

  def allows_rsvps?
    rsvps.count <= max_rsvps ? max_rsvps != 0 : false
  end

  def can_rsvp? user
    return false unless user and rsvp_permission_roles
    if user.is_officer_for_semester? MemberSemester.current
      true
    elsif user.is_active_member?
      %w[candidates committee_members].includes? rsvp_permission_roles
    else
      rsvp_permission_roles == "candidates"
    end
  end
end
