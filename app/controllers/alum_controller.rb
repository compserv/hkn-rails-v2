class AlumController < ApplicationController
  before_action :set_alum, only: [:show, :edit, :update, :destroy, :alumni_modification_authorization_filtration]
  before_filter :authenticate_alumrel!, only: [:index]
  before_filter :alumni_duplication_filtration, :only => [:new, :create]
  before_filter :authenticate_user!
  before_filter :alumni_modification_authorization_filtration, :only=> [:edit, :update, :destroy, :show]
  before_filter :input_helper, :only => [:create, :update]

  # GET /alumni
  def index
    @alumni = Alum.all.includes(:user)
  end

  # GET /alumni/1
  def show
  end

  def alumni_duplication_filtration
    if current_user.alum
      redirect_to edit_alum_path(current_user.alum), :notice => "You already have an alumni record. I've helpfully brought it up for you."
    end
  end

  # GET /alumni/new
  def new
    @alum = Alum.new
  end

  # GET /alumni/1/edit
  def edit
    grad_semester = @alum.grad_semester.split
    @grad_season = grad_semester[0] # Spring or Fall
    @grad_year = grad_semester[1] # the actual year
  end

  # POST /alumni
  def create
    params[:alum][:grad_semester] = Alum.grad_semester(params[:grad_season], params[:grad_year])
    params[:alum][:user_id] = current_user.id
    @alum = Alum.new(alum_params)

    if @alum.save
      redirect_to edit_alum_path(@alum), notice: 'Alum was successfully created.'
    else
      render :new
    end
  end

  def input_helper
    #Allow leading $, and seperators of , and _ (strip them)
    params[:alum][:salary].gsub!(/(^\$)|,|_/,'') if params[:alum] && params[:alum][:salary]
  end

  # PATCH/PUT /alumni/1
  def update
    params[:alum][:grad_semester] = Alum.grad_semester(params[:grad_season], params[:grad_year])
    debugger
    if @alum.update(alum_params)
      redirect_to @alum, notice: 'Alum was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /alumni/1
  def destroy
    @alum.destroy
    redirect_to new_alum_path, notice: 'Alum was successfully destroyed.'
  end

  def alumni_modification_authorization_filtration
    unless @alum and current_user.alum == @alum or authorize(:alumrel)
      redirect_to(:alert => "You're not authorized to modify someone else's alumni information!")
    end
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
