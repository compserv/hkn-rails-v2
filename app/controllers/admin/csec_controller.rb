class Admin::CsecController < ApplicationController
  def index
  end

  def select_classes
    m_sem = MemberSemester.current
    course_semester = CourseSemester.where(season: m_sem.season, year: m_sem.year).first_or_create
    @klasses = course_semester.course_offerings.includes(:course)
  end

  def manage_classes
  end

  def manage_candidates
  end

  def upload_surveys
  end
end
