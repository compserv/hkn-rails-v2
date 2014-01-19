# == Schema Information
#
# Table name: course_surveys
#
#  id                 :integer          not null, primary key
#  course_offering_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#  status             :string(255)
#  survey_time        :datetime
#  max_surveyors      :integer
#

class CourseSurvey < ActiveRecord::Base
  belongs_to :course_offering
  has_and_belongs_to_many :users, :join_table => :surveyors_candidates

  validates_presence_of :course_offering_id
  validates :max_surveyors, :numericality => true
  validates :status, :presence => true, :numericality => true

  @@statusmap = { 0 => "Not Done", 1 => "Contacted", 2 => "Scheduled", 3 => "Done" }

  def get_status_text
    @@statusmap[status]
  end

  def self.statusmap
    @@statusmap
  end

  before_validation :default_values
  def default_values
    self.max_surveyors ||= 3
    self.status ||= 0
  end

end
