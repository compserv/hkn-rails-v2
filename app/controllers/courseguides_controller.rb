class CourseguidesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update]
  before_filter :authenticate_tutoring!, :only=>[:edit, :update]

  def index
  end

  def show
    return redirect_to coursesurveys_search_path("#{params[:dept]} #{params[:course]}") unless @course
  end

  def edit
    if @course.nil?
      redirect_to coursesurveys_path, notice: "Error: No such course."
    end
  end

  def update
    redirect_to coursesurveys_path, notice: "Error: That course does not exist." and return unless @course
    if @course.update_attribute(:course_guide, params[:course_guide])
      flash[:notice] = "Successfully updated the course guide for #{@course.course_abbr}."
    else
      flash[:alert] = "Error updating the entry: #{@course.errors.inspect}"
    end

    redirect_to courseguide_show_path
  end

  def set_course
    @course = Course.find_by_department_and_course_name(params[:dept], params[:name])
  end
end
