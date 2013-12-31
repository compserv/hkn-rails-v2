class AlumniController < ApplicationController
  before_action :set_alum, only: [:show, :edit, :update, :destroy]
  # some kind of filter....
  # incorporate current user

  # GET /alumni
  def index
    @alumni = Alum.all
  end

  # GET /alumni/1
  def show
  end

  # GET /alumni/new
  def new
    @alum = Alum.new
  end

  # GET /alumni/1/edit
  def edit
  end

  # POST /alumni
  def create
    params[:alum][:grad_semester] = Alum.grad_semester(params[:grad_season], params[:grad][:year])
    @alum = Alum.new(alum_params)

    if @alum.save
      redirect_to alumni_path, notice: 'Alum was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /alumni/1
  def update
    params[:alum][:grad_semester] = Alum.grad_semester(params[:grad_season], params[:grad][:year])
    if @alum.update(alum_params)
      redirect_to @alum, notice: 'Alum was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /alumni/1
  def destroy
    @alum.destroy
    redirect_to alumni_url, notice: 'Alum was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alum
      @alum = Alum.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alum_params
      params.require(:alum).permit(:grad_semester, :grad_school, :job_title, :company, :salary, :user_id, :perm_email, :location, :suggestions, :mailing_list)
    end
end
