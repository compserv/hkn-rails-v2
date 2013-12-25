# == Schema Information
#
# Table name: exams
#
#  id                     :integer          not null, primary key
#  course_id              :integer          not null, foreign_key
#  exam_type              :string           not null
#  created_at             :datetime
#  updated_at             :datetime
#  number                 :integer
#  is_solution            :boolean
#  file_file_name         :string
#  file_content_type      :string
#  file_file_size         :string
#  file_updated_at        :datetime
#  year                   :integer
#  semester               :semester
#

class Exam < ActiveRecord::Base
  # TODO belongs_to course
  # has_many staff
  validates :exam_type, presence: true
  validates :year, presence: true
  validates :semester, inclusion: { in: %w(Summer Spring Winter),
    message: "%{value} is not a valid semester" }
  has_attached_file :file, :default_url => '/exams'
end
