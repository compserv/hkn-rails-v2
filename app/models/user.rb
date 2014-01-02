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
#

class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :rsvps
  has_many :events, through: :rsvps
  has_many :resumes, :dependent => :destroy
  has_one :alum

  has_and_belongs_to_many :member_semesters

  has_attached_file :picture, :default_url => "/pictures/:normalized_file_name.png", #guess saved as png to work w/ old system, if this gets updated (should only have to do it for current officers) can swap this to assets/person_placeholder.png
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
    # TODO(mark): This should be true for all officers and committee members.
    # Will add functionality when semesters + roles are working.
    true
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

  #this is sort of broken.
  def has_ever_had_role?(role)
    has_role? role
  end

  def is_current_officer?(position)
    roles_for_semester(MemberSemester.current).position(position).officers.count == 1
  end

  def is_officer_for_semester?(semester)
    roles_for_semester(semester).where(role_type: "officer").count > 0
  end

  def full_name
    first_name + " " + last_name
  end

  def status
    stat = roles_for_semester(MemberSemester.current).first
    dict = { "pres" => "President",
             "compserv" => "Computing Services Officer",
             "tutoring" => "Tutoring Officer"  } # not sure how to handle this yet.
    dict[stat.name] unless !stat
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

end
