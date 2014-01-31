class CoursesurveysController < ApplicationController
  def index
  end

  def show
    @course = Course.find_by_department_and_course_name(params[:dept], params[:name])
  end
end
