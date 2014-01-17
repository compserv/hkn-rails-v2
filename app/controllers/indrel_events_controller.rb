class IndrelEventsController < ApplicationController
  before_action :set_indrel_event, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_indrel!

  # GET /indrel_events
  def index
    @indrel_events = IndrelEvent.includes(:location, :indrel_event_type, :company, :contact).all.sort_by(&:time).reverse
  end

  # GET /indrel_events/1
  def show
  end

  # GET /indrel_events/new
  def new
    @indrel_event = IndrelEvent.new
  end

  # GET /indrel_events/1/edit
  def edit
  end

  # POST /indrel_events
  def create
    @indrel_event = IndrelEvent.new(indrel_event_params)

    if @indrel_event.save
      redirect_to @indrel_event, notice: 'Indrel event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /indrel_events/1
  def update
    if @indrel_event.update(indrel_event_params)
      redirect_to @indrel_event, notice: 'Indrel event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /indrel_events/1
  def destroy
    @indrel_event.destroy
    redirect_to indrel_events_url, notice: 'Indrel event was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_indrel_event
      @indrel_event = IndrelEvent.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def indrel_event_params
      params.require(:indrel_event).permit(:time, :location_id, :indrel_event_type_id, :food, :prizes, :turnout, :company_id, :contact_id, :officer, :feedback, :comments)
    end
end
