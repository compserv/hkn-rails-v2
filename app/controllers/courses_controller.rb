class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_csec!

  # GET /courses
  def index
    @courses = Course.all.sort_by {|x| [x.course_number, x.course_suffix] }
  end

  # GET /courses/1
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
    redirect_to courses_url, notice: 'Course was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:department, :course_name, :units)
    end
end
