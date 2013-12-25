class ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  # before_action authorize_stud_rel, only: [:create, :edit, :update, :destroy]

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
    debugger
    @exam = Exam.new(exam_params)

    if @exam.save
      redirect_to @exam, notice: 'Exam was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /exams/1
  def update
    if @exam.update(exam_params)
      redirect_to @exam, notice: 'Exam was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /exams/1
  def destroy
    @exam.destroy
    redirect_to exams_url, notice: 'Exam was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def exam_params
      params.require(:exam).permit(:course_id, :exam_type, :number, :is_solution, :file, :year, :semester)
    end
end
