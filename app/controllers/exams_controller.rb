class ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_studrel!, only: [:create, :edit, :update, :destroy]

  # GET /exams
  def index
    @dept_courses = {
      'Computer Science' => Course.where(department: 'CS'),
      'Electrical Engineering' => Course.where(department: 'EE')
    }

    @counts = Hash.new(0)
    Exam.includes(course_offering: :course).each do |x|
      @counts[x.course_offering.course.id] += 1
    end
  end

  # GET /exams/1
  def show
  end

  # GET /exams/new
  def new
    @exam = Exam.new
  end

  # GET /exams/1/edit
  def edit
  end

  # POST /exams
  def create
    @exam = Exam.new(exam_params)
    course = Course.find_by_id(params[:course_id])
    if course.nil?
      @exam.errors.add(:base, 'invalid course chosen')
      render :new and return
    end
    offering = course.course_offerings.joins(:course_semester).where('course_semesters.year = ? AND course_semesters.season = ?', exam_params[:year], exam_params[:semester]).first_or_create
    @exam.course_offering = offering

    if @exam.save
      redirect_to @exam, notice: 'Exam was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /exams/1
  def update
    course = Course.find_by_id(params[:course_id])
    if course.nil?
      @exam.errors.add(:base, 'invalid course chosen')
      render :new and return
    end
    offering = course.course_offerings.joins(:course_semester).where('course_semesters.year = ? AND course_semesters.season = ?', exam_params[:year], exam_params[:semester]).first_or_create
    @exam.course_offering = offering
    @exam.save
    if @exam.update(exam_params)
      redirect_to @exam, notice: 'Exam was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /exams/1
  def destroy
    @exam.destroy
    redirect_to exams_url, notice: 'Exam was successfully destroyed.'
  end

  def search
    @query = sanitize_query(params[:q])
    @course = Course.find_by_short_name(dept_abbr, full_course_num)
  end

  def course
    dept_abbr = params[:dept_abbr].upcase
    full_course_num = params[:full_course_number].upcase
    @course = Course.find_by_department_and_course_name(dept_abbr, full_course_num)
    redirect_to exams_search_path([dept_abbr,full_course_num].compact.join(' ')) unless @course
    offerings = CourseOffering.where(course_id: @course.id).reject {|offering| offering.exams.empty?}

    @results = offerings.collect do |offering|
      exams = {}
      solutions = {}
      offering.exams.includes(:course_offering).each do |exam|
        if exam.is_solution
          solutions[exam.short_type] = exam
        else
          exams[exam.short_type] = exam
        end
      end
      [offering.course_semester.name, offering.instructors.first, exams, solutions]
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def exam_params
      params.require(:exam).permit(:exam_type, :number, :is_solution, :file, :semester, :year)
    end
end
