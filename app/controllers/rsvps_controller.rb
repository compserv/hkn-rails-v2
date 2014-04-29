class RsvpsController < ApplicationController
  before_action :set_rsvp, only: [:show, :edit, :update, :destroy, :confirm, :unconfirm, :reject]
  before_filter :validate_owner!, only: [:edit, :update, :destroy]
  before_filter :vp_or_pres!, only: [:confirm, :unconfirm, :reject]
  before_filter :authenticate_user!
  before_filter :get_event, except: :my_rsvps
  before_filter :rsvp_permission!, only: [:new, :create]

  # GET /rsvps
  # GET /rsvps.xml
  def index
    # Most recently created RSVPs will show on top of the list
    @rsvps = @event.rsvps.order("created_at DESC").includes(:user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rsvps }
    end
  end

  # GET /rsvps/1
  # GET /rsvps/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rsvp }
    end
  end

  # GET /rsvps/new
  # GET /rsvps/new.xml
  def new
    redirect_to event_rsvps_path(params[:event_id].to_i), notice: "you've already rsvp'd" and return if current_user.events.pluck(:id).include?(params[:event_id].to_i)
    @rsvp = Rsvp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rsvp }
    end
  end

  # GET /rsvps/1/edit
  def edit
  end

  # POST /rsvps
  # POST /rsvps.xml
  def create
    redirect_to event_rsvps_path(params[:event_id].to_i), notice: "you've already rsvp'd" and return if current_user.events.pluck(:id).include?(params[:event_id].to_i)
    @rsvp = Rsvp.new(rsvp_params)
    @rsvp.event = @event
    @rsvp.user = current_user
    @rsvp.confirmed = Rsvp::Unconfirmed

    respond_to do |format|
      if @rsvp.save
        RSVPMailer.rsvp_email(current_user, @rsvp.event).deliver
        format.html { redirect_to(@event, :notice => 'Thanks for RSVPing! See you there!') }
        format.xml  { render :xml => @rsvp, :status => :created, :location => @rsvp }
      else
        format.html { render :new }
        format.xml  { render :xml => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rsvps/1
  # PUT /rsvps/1.xml
  def update

    respond_to do |format|
      if @rsvp.update_attributes(rsvp_params)
        format.html { redirect_to(@event, :notice => 'Rsvp was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :edit }
        format.xml  { render :xml => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rsvps/1
  # DELETE /rsvps/1.xml
  def destroy
    @event = @rsvp.event
    @rsvp.destroy

    respond_to do |format|
      format.html { redirect_to(@event) }
      format.xml  { head :ok }
    end
  end

  def confirm

    role = params[:role] || :candidates

    respond_to do |format|
      if @rsvp.update_attributes(confirmed: Rsvp::Confirmed, confirmed_by: current_user.id, confirmed_at: Time.now)
        format.html { redirect_to(confirm_rsvps_path(@rsvp.event_id, :role => role), :notice => 'Rsvp was confirmed.') }
        format.xml  { render :xml => @rsvp }
      else
        format.html { redirect_to confirm_rsvps_path(@rsvp.event_id, :role => role), :notice => 'Something went wrong.' }
        format.xml  { render :xml => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  def unconfirm
    @rsvp.update_attributes(confirmed: Rsvp::Unconfirmed, confirmed_by: current_user.id, confirmed_at: Time.now)
    role = params[:role] || "candidates"

    respond_to do |format|
      format.html { redirect_to(confirm_rsvps_path(@rsvp.event_id, :role => role), :notice => 'Confirmation was removed.') }
      format.xml { render :xml => @rsvp }
    end
  end

  def reject
    @rsvp.update_attributes(confirmed: Rsvp::Rejected, confirmed_by: current_user.id, confirmed_at: Time.now)
    role = params[:role] || "candidates"

    respond_to do |format|
      format.html { redirect_to(confirm_rsvps_path(@rsvp.event_id, :role => role), :notice => 'Confirmation was rejected.') }
      format.xml { render :xml => @rsvp }
    end
  end

  def my_rsvps
    @rsvps = current_user.rsvps.includes :event
  end

private

  def set_rsvp
    @rsvp = Rsvp.find(params[:id])
  end

  def vp_or_pres!
    authorize(:vp) || authenticate_pres!
  end

  def validate_owner!
    current_user == @rsvp.user || authenticate_superuser!
  end

  def get_event
    @event = Event.find params[:event_id] unless params[:event_id].blank?
    if !@event
      @event = Rsvp.find(params[:id]).event
    end
  end

  def rsvp_permission!
    if !@event.allows_rsvps? or !@event.can_rsvp? current_user
      redirect_to :root, :notice => "You do not have permission to RSVP for this event"
    end
  end

  def rsvp_params
    params.require(:rsvp).permit(:comment, :transportation_ability)
  end
end
