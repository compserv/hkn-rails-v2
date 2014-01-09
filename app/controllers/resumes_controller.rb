class ResumesController < ApplicationController
  before_action :set_resume, only: [:show, :edit, :update, :destroy, :include, :exclude]
  before_filter :authenticate_indrel!, :only => [:index, :resume_books, :upload_for, :include, :exclude, :status_list]
  before_filter :my_resume_or_indrel!, only: [:show, :edit, :update, :destroy]

  def my_resume_or_indrel!
    @resume.user.id == current_user.id || authenticate_indrel! # will redirect the user if both fail
  end

  # GET /resumes
  def index
    @resumes = Resume.includes(:user)
  end

  # GET /resumes/1
  def show
  end

  # GET /resumes/new
  def new
    if current_user.resume # help user just in case (multiple resumes for a single user aren't allowed)
      redirect_to edit_resume_path(current_user.resume) and return
    end
    @resume = Resume.new
  end

  # GET /resumes/1/edit
  def edit
  end

  # POST /resumes
  def create
    params[:resume][:user_id] ||= current_user.id # account for indrel potentially uploading for someone.
    params[:resume][:included] = true # by default resumes are included.
    @resume = Resume.new(resume_params)
    my_resume_or_indrel! # security verification.

    if @resume.save
      redirect_to @resume, notice: 'Resume was successfully created.'
    else
      if @resume.user.id != current_user.id # save this silly indrel from havoc
        redirect_to resumes_upload_for_path(@resume.user.id), alert: @resume.errors.full_messages.to_s and return
      end
      render :new
    end
  end

  # PATCH/PUT /resumes/1
  def update
    if @resume.update(resume_params)
      redirect_to @resume, notice: 'Resume was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /resumes/1
  def destroy
    @resume.destroy
    redirect_to new_resume_path, notice: 'Resume was successfully destroyed.'
  end

  def upload_for
    @user = User.find_by_id(params[:user_id])
    if @user.resume
      redirect_to edit_resume_path(@user.resume), alert: "#{@user.full_name} has a resume already" and return
    end
    @resume = Resume.new
  end

  def download
    @resume = Resume.find(params[:id])
    my_resume_or_indrel!
    send_file @resume.file.path, type: @resume.file_content_type,
                                 filename: @resume.file_file_name,
                                 disposition: 'inline' # loads file in browser for now.
  end

  def status_list
    @officers = Role.semester_filter(MemberSemester.current).officers.all_users_resumes
    @candidates = Role.semester_filter(MemberSemester.current).candidates.all_users_resumes
    @everyone_else = User.all.includes(:resume).find_all {|p| not (@officers.include?(p) or @candidates.include?(p))}
  end

  # intended for ajax
  def include
    @resume.update_attribute :included, true
    render :js => 'location.reload();'
  end

  def exclude
    @resume.update_attribute :included, false
    render :js => 'location.reload();'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume
      @resume = Resume.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def resume_params
      params.require(:resume).permit(:overall_gpa, :major_gpa, :resume_text, :graduation_year, :graduation_semester, :user_id, :included, :file)
    end
end
