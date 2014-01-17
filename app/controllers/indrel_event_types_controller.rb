class IndrelEventTypesController < ApplicationController
  before_action :set_indrel_event_type, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_indrel!

  # GET /indrel_event_types
  def index
    @indrel_event_types = IndrelEventType.all.sort_by(&:name)
  end

  # GET /indrel_event_types/1
  def show
  end

  # GET /indrel_event_types/new
  def new
    @indrel_event_type = IndrelEventType.new
  end

  # GET /indrel_event_types/1/edit
  def edit
  end

  # POST /indrel_event_types
  def create
    @indrel_event_type = IndrelEventType.new(indrel_event_type_params)

    if @indrel_event_type.save
      redirect_to @indrel_event_type, notice: 'Indrel event type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /indrel_event_types/1
  def update
    if @indrel_event_type.update(indrel_event_type_params)
      redirect_to @indrel_event_type, notice: 'Indrel event type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /indrel_event_types/1
  def destroy
    @indrel_event_type.destroy
    redirect_to indrel_event_types_url, notice: 'Indrel event type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_indrel_event_type
      @indrel_event_type = IndrelEventType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def indrel_event_type_params
      params.require(:indrel_event_type).permit(:name)
    end
end
