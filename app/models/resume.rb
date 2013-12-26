# == Schema Information
#
# Table name: resumes
#
#  id                  :integer          not null, primary key
#  overall_gpa         :decimal(, )
#  major_gpa           :decimal(, )
#  resume_text         :text
#  graduation_year     :integer
#  graduation_semester :string(255)
#  user_id             :integer
#  included            :boolean
#  created_at          :datetime
#  updated_at          :datetime
#  file_file_name      :string(255)
#  file_content_type   :string(255)
#  file_file_size      :integer
#  file_updated_at     :datetime
#

class Resume < ActiveRecord::Base
  belongs_to :user
  validates :overall_gpa, presence: true
  validates :resume_text, :presence => true
  validates :graduation_year, :numericality => true
  validates :graduation_semester, inclusion: { in: %w(sp fa),
      message: "%{value} is not a valid semester" }
  validates :included, :inclusion => [true,false]
end
