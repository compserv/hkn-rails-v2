# == Schema Information
#
# Table name: course_surveys
#
#  id                     :integer          not null, primary key
#  staff_member_id        :integer
#  course_staff_member_id :integer
#  course_offering_id     :integer
#  course_id              :integer
#  course_semester_id     :integer
#  created_at             :datetime
#  updated_at             :datetime
#


class CourseSurvey < ActiveRecord::Base
  belongs_to :course_staff_member
  has_many :survey_questions

  validates :course_id, presence: true
  validates :course_offering_id, presence: true
  validates :course_semester_id, presence: true
  validates :staff_member_id, presence: true
  validates :course_staff_member_id, presence: true
end
