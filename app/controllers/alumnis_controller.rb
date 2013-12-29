class AlumnisController < ApplicationController
  before_action :set_alumni, only: [:show, :edit, :update, :destroy]
  # some kind of filter....
  # incorporate current user

  # GET /alumnis
  def index
    @alumnis = Alumni.all
  end

  # GET /alumnis/1
  def show
  end

  # GET /alumnis/new
  def new
    @alumni = Alumni.new
  end

  # GET /alumnis/1/edit
  def edit
  end

  # POST /alumnis
  def create
    params[:alumni][:grad_semester] = Alumni.grad_semester(params[:grad_season], params[:grad][:year])
    @alumni = Alumni.new(alumni_params)

    if @alumni.save
      redirect_to @alumni, notice: 'Alumni was successfully created.'
    else
      redirect_to new_alumni_path(@dept_tour), alert: "#{@alumni.errors.full_messages.join(', ')}"
    end
  end

  # PATCH/PUT /alumnis/1
  def update
    params[:alumni][:grad_semester] = Alumni.grad_semester(params[:grad_season], params[:grad][:year])
    if @alumni.update(alumni_params)
      redirect_to @alumni, notice: 'Alumni was successfully updated.'
    else
      redirect_to edit_alumni_path(@dept_tour), alert: "#{@alumni.errors.full_messages.join(', ')}"
    end
  end

  # DELETE /alumnis/1
  def destroy
    @alumni.destroy
    redirect_to alumnis_url, notice: 'Alumni was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alumni
      @alumni = Alumni.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alumni_params
      params.require(:alumni).permit(:grad_semester, :grad_school, :job_title, :company, :salary, :user_id, :perm_email, :location, :suggestions, :mailing_list)
    end
end
