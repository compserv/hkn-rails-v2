# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Announcement < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :body, :user_id

  def usersname
    user.full_name
  end
end
