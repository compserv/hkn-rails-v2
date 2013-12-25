class DeptToursController < ApplicationController
  before_action :set_dept_tour, only: [:show, :edit, :update, :destroy]

  # GET /dept_tours
  def index
    @dept_tours = DeptTour.all
  end

  # GET /dept_tours/1
  def show
  end

  # GET /dept_tours/new
  def new
    @dept_tour = DeptTour.new
  end

  # GET /dept_tours/1/edit
  def edit
  end

  # POST /dept_tours
  def create
    params[:responded] = false
    @dept_tour = DeptTour.new(dept_tour_params)

    if @dept_tour.save
      redirect_to @dept_tour, notice: 'Dept tour was successfully created.'
    else
      redirect_to new_dept_tour_path, alert: "#{@dept_tour.errors.messages}"
    end
  end

  # PATCH/PUT /dept_tours/1
  def update
    if @dept_tour.update(dept_tour_params)
      redirect_to @dept_tour, notice: 'Dept tour was successfully updated.'
    else
      redirect_to edit_dept_tour_path(@dept_tour), alert: "#{@dept_tour.errors.messages}"
    end
  end

  # DELETE /dept_tours/1
  def destroy
    @dept_tour.destroy
    redirect_to dept_tours_url, notice: 'Dept tour was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dept_tour
      @dept_tour = DeptTour.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dept_tour_params
      params.require(:dept_tour).permit(:name, :date, :email, :phone, :submitted, :comments, :responded)
    end
end
