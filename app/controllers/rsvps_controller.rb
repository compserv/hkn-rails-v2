class RsvpsController < ApplicationController
  before_filter :get_event, except: :my_rsvps
  before_filter :rsvp_permission, only: :new
  #before_filter(:only => [:confirm, :unconfirm, :reject]) { |c| c.authorize(['pres', 'vp']) }
  before_filter :comm_authorize
  before_filter { |controller| controller.authorize(:compserv) }

  # GET /rsvps
  # GET /rsvps.xml
  def index
    # Most recently created RSVPs will show on top of the list
    @rsvps = @event.rsvps.order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rsvps }
    end
  end

  # GET /rsvps/1
  # GET /rsvps/1.xml
  def show
    @rsvp = Rsvp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rsvp }
    end
  end

  # GET /rsvps/new
  # GET /rsvps/new.xml
  def new
    @rsvp = Rsvp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rsvp }
    end
  end

  # GET /rsvps/1/edit
  def edit
    @rsvp = Rsvp.find(params[:id])
    validate_owner!(@rsvp)
  end

  # POST /rsvps
  # POST /rsvps.xml
  def create
    @rsvp = Rsvp.new(rsvp_params)
    @rsvp.event = @event
    @rsvp.user = current_user

    respond_to do |format|
      if @rsvp.save
        format.html { redirect_to(@event, :notice => 'Thanks for RSVPing! See you there!') }
        format.xml  { render :xml => @rsvp, :status => :created, :location => @rsvp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rsvps/1
  # PUT /rsvps/1.xml
  def update
    @rsvp = Rsvp.find(params[:id])
    validate_owner!(@rsvp)

    @rsvp.update_attributes(rsvp_params)

    respond_to do |format|
      if @rsvp.save
        format.html { redirect_to(@event, :notice => 'Rsvp was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rsvps/1
  # DELETE /rsvps/1.xml
  def destroy
    @rsvp = Rsvp.find(params[:id])
    validate_owner!(@rsvp)
    @event = @rsvp.event
    @rsvp.destroy

    respond_to do |format|
      format.html { redirect_to(@event) }
      format.xml  { head :ok }
    end
  end

  def confirm
    @rsvp = Rsvp.find(params[:id])
    @rsvp.confirmed = Rsvp::Confirmed

    group = params[:group] || "candidates"

    respond_to do |format|
      if @rsvp.update_attribute :confirmed, Rsvp::Confirmed   # TODO (jonko) this bypasses validation
        format.html { redirect_to(confirm_rsvps_path(@rsvp.event_id, :group => group), :notice => 'Rsvp was confirmed.') }
        format.xml  { render :xml => @rsvp }
      else
        format.html { redirect_to confirm_rsvps_path(@rsvp.event_id, :group => group), :notice => 'Something went wrong.' }
        format.xml  { render :xml => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  def unconfirm
    @rsvp = Rsvp.find(params[:id])
    @rsvp.update_attribute :confirmed, Rsvp::Unconfirmed # TODO (jonko)

    group = params[:group] || "candidates"

    respond_to do |format|
      format.html { redirect_to(confirm_rsvps_path(@rsvp.event_id, :group => group), :notice => 'Confirmation was removed.') }
      format.xml { render :xml => @rsvp }
    end
  end

  def reject
    @rsvp = Rsvp.find(params[:id])
    @rsvp.update_attribute :confirmed, Rsvp::Rejected # TODO (jonko)
    
    group = params[:group] || "candidates"

    respond_to do |format|
      format.html { redirect_to(confirm_rsvps_path(@rsvp.event_id, :group => group), :notice => 'Confirmation was rejected.') }
      format.xml { render :xml => @rsvp }
    end
  end

  def my_rsvps
    @rsvps = current_user.rsvps.includes :event
  end

private

  def validate_owner!(rsvp)
    unless current_user == rsvp.user || authorize(:compserv)
      raise 'You do not have permission to modify this RSVP'
    end
  end

  def get_event
    @event = Event.find params[:event_id] unless params[:event_id].blank?
    if !@event
      @event = Rsvp.find(params[:id]).event
    end
  end

  def rsvp_permission
    if !@event.allows_rsvps? or !@event.can_rsvp? current_user
      redirect_to :root, :notice => "You do not have permission to RSVP for this event"
      return false
    end
  end

  def rsvp_params
    params.require(:rsvp).permit(:comment, :transportation_ability)
  end
end
