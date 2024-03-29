class CoursesurveysController < ApplicationController
  def index
  end

  def show
    @course = Course.find_by_department_and_course_name(params[:dept], params[:name])
  end

  def department
    @department = params[:dept].upcase
    @prof_eff_q  = SurveyQuestion.find_by_keyword(:prof_eff)
    @lower_div   = []
    @upper_div   = []
    @grad        = []
    @full_list   = params[:full_list].present? # this needs to be taken into account later
    @semester    = params[:semester] && params[:year] ? CourseSemester.where(season: params[:semester], year: params[:year]).first : nil
    # Error checking
    return redirect_to coursesurveys_search_path("#{params[:dept_abbr]} #{params[:short_name]}") unless @department

    Course.where(department: @department).
        includes(:survey_question_responses, :course_offerings, :course_semesters, :staff_members, :course_semesters).
        where('course_staff_members.staff_role = ?', 'prof').
        where('survey_question_responses.survey_question_id = ?', @prof_eff_q.id).
        references(:survey_question_responses).
        each do |course|
      next if course.invalid?

      # Find only the most recent course, optionally with a lower bound on semester
      first_course = course.course_offerings
      #first_course = first_course.where(:semester => Property.make_semester(:year=>4.years.ago.year)..Property.make_semester) unless @full_list
      #first_course = first_course.where(:semester => @semester) if @semester
      first_course = first_course.first
      #first_course = first_course.find(:first, :include => {:instructorships => :instructor} )

      # Sometimes the latest course is really old, and not included in these results
      next unless first_course.present?

      next unless avg_rating = course.survey_question_responses.average(:rating)

      # Generate row
      instructors = course.staff_members
      result = { :course      => course,
                 :instructors => instructors,
                 :mean        => avg_rating,
                 :klass       => first_course  }

      # Append course to correct list
      case course.course_number.to_i
        when   0.. 99 then @lower_div
        when 100..199 then @upper_div
        else           @grad
      end << result
    end
  end
end
