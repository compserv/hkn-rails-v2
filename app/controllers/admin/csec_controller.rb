class Admin::CsecController < ApplicationController
  before_filter :authenticate_csec!

  def index
  end

  def select_classes
    m_sem = MemberSemester.current
    course_semester = CourseSemester.where(season: m_sem.season, year: m_sem.year).first_or_create
    @offerings = course_semester.course_offerings.includes(:course, :course_survey).order('courses.department', 'courses.course_name')
  end

  def select_classes_post
    m_sem = MemberSemester.current
    course_semester = CourseSemester.where(season: m_sem.season, year: m_sem.year).first_or_create
    course_semester.course_offerings.includes(:course_survey).each do |offering|
      if params.has_key?("offering#{offering.id}") and offering.course_survey.nil?
        # This should not fail
        CourseSurvey.create!(course_offering: offering)
      elsif !params.has_key?("offering#{offering.id}") and !offering.coursesurvey.nil?
        offering.course_survey.delete
      end
    end
    m_sem.coursesurveys_active = !params[:coursesurveys_active].blank?
    m_sem.save
    redirect_to admin_csec_select_classes_path, :notice => "Updated classes to be surveyed"
  end

  def manage_classes
    m_sem = MemberSemester.current
    course_semester = CourseSemester.where(season: m_sem.season, year: m_sem.year).first_or_create
    @coursesurveys = course_semester.course_surveys.includes({course_offering: :course}, :users)
  end

  def manage_candidates
  end

  def upload_surveys
  end
end
