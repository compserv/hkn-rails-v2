class ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_studrel!, only: [:create, :edit, :update, :destroy]

  # GET /exams
  def index
    @exams = Exam.all
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
    offering = Course.find_by_id(params[:course_id]).course_offerings.joins(:course_semester).where('course_semesters.year = ? AND course_semesters.season = ?', exam_params[:year], exam_params[:semester]).first
    @exam.course_offering = offering
    debugger

    if @exam.save
      redirect_to @exam, notice: 'Exam was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /exams/1
  def update
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def exam_params
      params.require(:exam).permit(:exam_type, :number, :is_solution, :file)
    end
end
