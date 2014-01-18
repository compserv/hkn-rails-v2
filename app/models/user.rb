# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)      not null
#  first_name             :string(255)
#  last_name              :string(255)
#  picture_file_name      :string(255)
#  picture_content_type   :string(255)
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  approved               :boolean          default(FALSE), not null
#  private                :boolean
#  date_of_birth          :date
#  phone_number           :string(255)
#  sms_alerts             :boolean
#  candidate_quiz_id      :integer
#  mobile_carrier_id      :integer
#  should_reset_session   :boolean
#  local_address          :string(255)
#  perm_address           :string(255)
#  committee_preferences  :string(255)
#  suggestion             :text
#  graduation_semester    :string(255)
#

class User < ActiveRecord::Base
  rolify
  has_and_belongs_to_many :course_surveys, :join_table => :surveyors_candidates
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :rsvps
  has_many :events, through: :rsvps
  has_one :resume, :dependent => :destroy
  has_one :alum
  belongs_to :mobile_carrier
  has_many :tutor_slot_preferences

  has_one :candidate_quiz

  has_and_belongs_to_many :member_semesters

  has_attached_file :picture, :default_url => "/pictures/:normalized_file_name.png", #guess saved as png to work w/ old system, if this gets updated (should only have to do it for current officers) can swap this to assets/person_placeholder.png
      :styles => {original: "125x100#"},
      :path => ":rails_root/public/pictures/:normalized_file_name.:extension",
      :url => "/pictures/:normalized_file_name.:extension"

  validates_attachment_content_type :picture,
      :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png", "application/pdf"],
      :message => "Oops, please use a jpg/gif/png/pdf"

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    self.username
  end

  def rsvp!(event_id)
    rsvps.create!(event_id: event_id)
  end

  def is_active_member?
    Role.semester_filter(MemberSemester.current).members.all_users.include?(self)
  end

  def is_member?
    roles.members.count > 0
  end

  def add_position_for_semester_and_role_type(position, semester, role)
    Role.find_or_create_by_name_and_resource_id_and_role_type_and_resource_type(position, semester.id, role, "MemberSemester").users << self
  end

  def has_position_for_semester_and_role_type(position, semester, role)
    Role.find_by_name_and_resource_id_and_role_type(position, semester.id, role)
  end

  def delete_position_for_semester_and_role_type(position, semester, role)
    Role.find_by_name_and_resource_id_and_role_type(position, semester.id, role).users.delete(self)
  end

  def delete_role(r) # r should be an object of Role class
    r.users.delete(self)
  end

  # Helpers for adding and checking roles for a user.
  def add_role_for_semester(role, semester)
    add_role role, semester
  end

  def roles_for_semester(semester)
    roles.where(resource_type: MemberSemester, resource_id: semester.id)
  end

  def has_role_for_semester?(role, semester)
    has_role? role, semester
  end

  def has_role_for_current_semester?(role)
    has_role_for_semester? role, MemberSemester.current
  end

  def has_ever_had_role?(role)
    roles.where(role_type: role).count > 0
  end

  def has_ever_had_position_role?(position, role)
    roles.where(name: position, role_type: role).count > 0
  end

  def has_ever_had_position?(position)
    roles.where(name: position).count > 0
  end

  def is_current_officer?(position)
    roles_for_semester(MemberSemester.current).position(position).officers.count == 1
  end

  def is_officer_for_semester?(semester)
    roles_for_semester(semester).officers.count > 0
  end

  def is_currently_candidate?
    roles_for_semester(MemberSemester.current).candidates.count > 0
  end

  def full_name
    first_name + " " + last_name
  end

  def status
    roles_for_semester(MemberSemester.current).map{|x| x.nice_position}.join(', ')
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def phone_number_is_valid?
    phone_number_compact.size == 10
  end

  def phone_number_compact
    return "" unless n = read_attribute(:phone_number) and not n.blank?
    n.gsub /[^\d]/, ''
  end

  def sms_email_address
    return "" unless phone_number_is_valid? and not mobile_carrier.blank?
    "#{phone_number_compact}#{mobile_carrier.sms_email}"
  end

  # Sends an SMS message with the provided text if the user has sms_alerts enabled
  def send_sms!(msg)
    return false unless sms_alerts and phone_number_is_valid? and not mobile_carrier.blank?
    UserMailer.send_sms(self, msg).deliver
  end

  def phone_number_fix
    return unless self.phone_number
    n = self.phone_number.gsub /[^\d]/, ''
    return unless n && n.length == 10
    self.phone_number = "(#{n[0..2]}) #{n[3..5]}-#{n[6..9]}"
  end

  def as_email
    return "\"#{full_name}\" <#{email}>"
  end

end
