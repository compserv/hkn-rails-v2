class CourseguidesController < ApplicationController
  before_filter :authenticate_tutoring!, :only=>[:edit, :update]

  def index
  end

  def show
    @course = Course.find_by_short_name(params[:dept_abbr], params[:course_number])
    @can_edit = authorize(:tutoring)
    return redirect_to coursesurveys_search_path("#{params[:dept_abbr]} #{params[:course_number]}") unless @course
  end

  def edit
    @course = Course.find_by_short_name(params[:dept_abbr], params[:course_number])
    if @course.nil?
      redirect_back_or_default coursesurveys_path, :notice => "Error: No such course."
    end
  end

  def update
    @course = Course.find_by_short_name(params[:dept_abbr], params[:course_number])
    if @course.nil?
      return redirect_back_or_default coursesurveys_path, :notice=>"Error: That course does not exist."
    end

    if !@course.update_attributes(params[:course])
      return redirect_to courseguide_show_path(@course.dept_abbr, @course.full_course_number), :notice => "Error updating the entry: #{@course.errors.inspect}"
    end

    return redirect_to courseguide_edit_path(@course.dept_abbr, @course.full_course_number), :notice => "Successfully updated the course guide for #{@course.course_name}."
  end
end
