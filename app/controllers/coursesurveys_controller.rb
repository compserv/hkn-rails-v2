class CoursesurveysController < ApplicationController
  def index
  end

  def show
    @course = Course.find_by_department_and_course_name(params[:dept], params[:name])

    # Try searching if no course was found
    return redirect_to coursesurveys_search_path("#{params[:dept_abbr]} #{params[:course_number]}") unless @course

    # eager-load all necessary data. wasteful course reload, but can't get around the _short_name helper.
    @course = Course.find(@course.id)

    effective_q  = SurveyQuestion.find_by_keyword(:prof_eff)
    worthwhile_q = SurveyQuestion.find_by_keyword(:worthwhile)

    @results = []
    @overall = { :effectiveness  => {:max=>effective_q.max },
                 :worthwhile     => {:max=>worthwhile_q.max}
               }

    @course.course_offerings.each do |klass|
      next unless klass.survey_question_responses.exists?
      result = { klass: klass, ratings: [] }

      klass.instructors.sort{|x,y| x.last_name <=> y.last_name}.each do |instructor|
        rating = { instructor: instructor }

        catch :nil_answer do
          # Some heavier computations
          [ [:effectiveness, effective_q ],
            [:worthwhile,    worthwhile_q]
          ].each do |qname, q|
            answer = klass.survey_question_responses.where(survey_question_id: q.id, :course_staff_member_id => instructor.id).first
            if answer.nil?
              logger.warn "coursesurveys#course: nil score for #{klass.to_s} question #{q.question_text}"
              throw :nil_answer
            else
              rating[qname] = answer.rating
            end
          end
          result[:ratings] << rating
        end
      end

      @results << result
    end # @course.klasses

    [ :effectiveness, :worthwhile ].each do |qname|
      @overall[qname][:score] = @results.collect do |result|
        result[:ratings].map{|r| r[qname]}.sum.to_f/result[:ratings].size
      end.sum / @results.size.to_f
    end
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
