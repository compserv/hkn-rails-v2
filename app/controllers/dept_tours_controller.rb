class DeptToursController < ApplicationController
  before_action :set_dept_tour, only: [:show, :edit, :update, :destroy, :respond_to_tour]
  # before_action :authorize_indrel, only: [:show, :edit, :update, :destroy, :respond_to_tour]

  # GET /dept_tours
  def index
    @dept_tours = DeptTour.order(:responded)
    @dept_tours_requests_length = DeptTour.where(:responded => false).count

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dept_tours }
    end
  end

  # GET /dept_tours/1
  def show
    @default_response_text = get_default_response_text(@dept_tour)
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
    params[:dept_tour][:responded] = false
    params[:dept_tour][:submitted] = Time.now
    @dept_tour = DeptTour.new(dept_tour_params)
    unless params[:email_confirmation] == params[:dept_tour][:email]
      @dept_tour.errors[:base] << "Email confirmation doesn't match"
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
    redirect_to dept_tours_url, notice: 'Dept tour was successfully destroyed.'
  end

  def success
  end

  def get_default_response_text(dept_tour_request)
    "Hello #{dept_tour_request.name},

    This email is a confirmation of your requested department tour on #{dept_tour_request.date.strftime("%A, %B %d, at %I:%M %p")}.

    Please meet me, or one of our other officers, at 345 Soda Hall at that time.

    Looking forward to seeing you!

    --#{current_user.full_name}
    "
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
      params.require(:dept_tour).permit(:name, :date, :email, :phone, :submitted, :comments, :responded)
    end
end
