class CourseguidesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update]
  before_filter :authenticate_tutoring!, :only=>[:edit, :update]

  def index
  end

  def show
    redirect_to coursesurveys_search_path("#{params[:dept]} #{params[:course]}") and return unless @course
  end

  def edit
    redirect_to coursesurveys_path, alert: "Error: No such course." and return unless @course
  end

  def update
    redirect_to coursesurveys_path, alert: "Error: That course does not exist." and return unless @course
    if @course.update_attribute(:course_guide, params[:course_guide])
      redirect_to courseguide_show_path, notice: "Successfully updated the course guide for #{@course.course_abbr}."
    else
      redirect_to courseguide_edit_path, alert: "Error updating the entry: #{@course.errors.inspect}"
    end
  end

  def set_course
    @course = Course.find_by_department_and_course_name(params[:dept], params[:name])
  end
end
