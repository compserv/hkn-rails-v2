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

  def manage_classes_post
    params.keys.reject{|x| !(x =~ /^survey[0-9]*$/)}.each do |param_id|
      id = param_id[6..-1]
      coursesurvey = CourseSurvey.find_by_id(id) # This should not fail
      coursesurvey.update_attributes(params[param_id].permit(:status, :max_surveyors))
      if !coursesurvey.valid?
        redirect_to admin_csec_manage_classes_path, notice: "Error happened. Your input was probably not valid." and return
      end
    end
    redirect_to admin_csec_manage_classes_path, notice: "Updated classes"
  end

  def manage_candidates
  end

  def upload_surveys
  end

  def coursesurvey_show
    @coursesurvey = CourseSurvey.includes(:users).find_by_id(params[:id])
    redirect_to admin_csec_manage_classes_path, notice: "Invalid coursesurvey ID" and return unless @coursesurvey
  end

  def coursesurvey_remove
    @coursesurvey = CourseSurvey.find_by_id(params[:coursesurvey_id])
    @user = User.find_by_id(params[:user_id])

    return redirect_to admin_csec_manage_classes_path, :notice => "Invalid coursesurvey ID" unless @coursesurvey
    return redirect_to admin_csec_coursesurvey_path(@coursesurvey), notice: "Invalid person ID" unless @user
    return redirect_to admin_csec_coursesurvey_path(@coursesurvey), notice: "#{@user.full_name} is not surveying #{@coursesurvey.course_offering.to_s}" unless @coursesurvey.users.include?(@user)

    @coursesurvey.users.delete(@user)
    @coursesurvey.save

    redirect_to admin_csec_coursesurvey_path(@coursesurvey), :notice => "Removed #{@user.full_name} from #{@coursesurvey.course_offering.to_s} survey"
  end
end
