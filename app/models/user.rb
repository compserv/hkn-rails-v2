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
#

class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :rsvps
  has_many :events, through: :rsvps

  has_and_belongs_to_many :member_semesters
  has_many :semester_roles, through: :member_semesters
  has_many :roles, through: :semester_roles

  def rsvp!(event_id)
    rsvps.create!(event_id: event_id)
  end

  def is_active_member?
    # TODO(mark): This should be true for all officers and committee members.
    # Will add functionality when semesters + roles are working.
    true
  end

end
