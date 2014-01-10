class DeptToursController < ApplicationController
  before_action :set_dept_tour, only: [:show, :edit, :update, :destroy, :respond_to_tour]
  before_action :authenticate_deprel!, only: [:show, :edit, :update, :destroy, :respond_to_tour]

  # GET /dept_tours
  def index
    @dept_tour_requests_pending = DeptTour.find_all_by_responded(true)
    @dept_tour_requests_unresponded = DeptTour.find_all_by_responded(false)
    @dept_tours_requests_length = DeptTour.all.count

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dept_tours }
    end
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
    @dept_tour = DeptTour.new(dept_tour_params)
    @dept_tour.responded = false  # when created they can't be responded to already
    unless params[:email_confirmation] == params[:dept_tour][:email]
      @dept_tour.errors[:base] << "Email confirmation doesn't match"
      @dept_tour.email = nil # force them to retype both fields, they probably messed up.
      render :new and return
    end
    if verify_recaptcha(:model => @dept_tour, :message => "oops recaptcha failed!") && @dept_tour.save
      mail = DeptTourMailer.dept_tour_email dept_tour_params[:name], @dept_tour.date, dept_tour_params[:email],
          dept_tour_params[:phone], dept_tour_params[:comments]
      mail.deliver
      redirect_to dept_tours_success_path
    else
      flash.delete(:recaptcha_error)
      render :new
    end
  end

  # PATCH/PUT /dept_tours/1
  def update
    if @dept_tour.update(dept_tour_params)
      redirect_to @dept_tour, notice: 'Dept tour was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dept_tours/1
  def destroy
    @dept_tour.destroy
    redirect_to dept_tours_url, notice: "The request has been dismissed. I hope you're happy."
  end

  def success
  end

  def respond_to_tour
    @dept_tour.responded = true
    @dept_tour.save!
    mail = DeptTourMailer.dept_tour_response_email(@dept_tour, params[:response], params[:from], params[:ccs])
    mail.deliver
    redirect_to dept_tour_path(@dept_tour), notice: 'Successfully responded'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dept_tour
      @dept_tour = DeptTour.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dept_tour_params
      params.require(:dept_tour).permit(:name, :date, :email, :phone, :comments, :responded)
    end
end
