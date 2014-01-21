class Admin::CsecController < ApplicationController
  def index
  end

  def select_classes
    m_sem = MemberSemester.current
    course_semester = CourseSemester.where(season: m_sem.season, year: m_sem.year).first_or_create
    @klasses = course_semester.course_offerings.includes(:course).order('courses.department', 'courses.course_name')
  end

  def select_classes_post
    m_sem = MemberSemester.current
    course_semester = CourseSemester.where(season: m_sem.season, year: m_sem.year).first_or_create
    course_semester.course_offerings.each do |offering|
      offering.update_attribute :coursesurveys_active, params.has_key?("offering#{offering.id}")
    end
    m_sem.coursesurveys_active = !params[:coursesurveys_active].blank?
    m_sem.save
    redirect_to admin_csec_select_classes_path, :notice => "Updated classes to be surveyed"
  end

  def manage_classes
  end

  def manage_candidates
  end

  def upload_surveys
  end
end
