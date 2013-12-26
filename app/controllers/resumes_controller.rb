class ResumesController < ApplicationController
  before_action :set_resume, only: [:show, :edit, :update, :destroy]

  # GET /resumes
  def index
    @resumes = Resume.all
  end

  # GET /resumes/1
  def show
  end

  # GET /resumes/new
  def new
    @resume = Resume.new
  end

  # GET /resumes/1/edit
  def edit
  end

  # POST /resumes
  def create
    debugger
    @resume = Resume.new(resume_params)

    if @resume.save
      redirect_to @resume, notice: 'Resume was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /resumes/1
  def update
    if @resume.update(resume_params)
      redirect_to @resume, notice: 'Resume was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /resumes/1
  def destroy
    @resume.destroy
    redirect_to resumes_url, notice: 'Resume was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume
      @resume = Resume.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def resume_params
      params.require(:resume).permit(:overall_gpa, :major_gpa, :resume_text, :graduation_year, :graduation_semester, :user_id, :included)
    end
end
