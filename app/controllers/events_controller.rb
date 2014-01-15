class EventsController < ApplicationController
  before_filter :event_authorize
  before_filter :comm_authorize!, except: [:index, :show, :calendar]

  def index
    per_page = 20

    if Event::VALID_SORT_FIELDS.include?(params[:sort])
      order = params[:sort]
    else
      order = "start_time"
    end
    
    event_filter = params[:event_filter] || "none"
    params[:sort_direction] ||= (params[:category] == 'past') ? 'down' : 'up'

    sort_direction = case params[:sort_direction]
                     when "up" then "ASC"
                     when "down" then "DESC"
                     else "ASC"
                     end
    @search_opts = {'sort' => order, 'sort_direction' => sort_direction }.merge params
    # Maintains start_time as secondary sort column
    options = { :page => params[:page], :per_page => per_page, :order => "#{order} #{sort_direction}, start_time #{sort_direction}" }

    category = params[:category] || 'all'
    event_finder = Event.with_permission(current_user)

    if category == 'past'
      @events = event_finder.past
      @heading = "Past Events"
    elsif category == 'future'
      @events = event_finder.upcoming
      @heading = "Upcoming Events"
    else
      @events = event_finder
      @heading = "All Events"
    end

    if event_filter != "none"
      @events = @events.select {|e| e.event_type.downcase == event_filter}
    end

    if order == "event_type"
      opts = { page: params[:page], per_page: per_page }
      @events = @events.sort_by{|event| event.event_type }
      @events = @events.paginate options
    else
      @events = @events.paginate options
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js { render :partial => 'list' }
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def create
    @event = Event.new(event_params)
    valid = true

    if @event.valid?
      @event.save!
    else
      valid = false
    end

    respond_to do |format|
      if valid
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    valid = @event.update_attributes(event_params)

    respond_to do |format|
      if valid
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    unless @event = Event.find(params[:id])
      # no such event
      flash[:notice] = "Invalid event #{params[:id]}"
      redirect_to events_path
      return
    end

    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event.start_time = @event.start_time.in_time_zone("Pacific Time (US & Canada)").strftime("%Y-%m-%d %I:%M %P")
    @event.end_time = @event.end_time.in_time_zone("Pacific Time (US & Canada)").strftime("%Y-%m-%d %I:%M %P")
  end

  def show
    begin
      # Only show event if user has permission to
      @event = Event.with_permission(current_user).find(params[:id], include: { rsvps: :user } )
    rescue ActiveRecord::RecordNotFound
      redirect_to :root, :notice => "Event not found"
      return
    end
    @current_user_rsvp = @event.rsvps.find_by_user_id(current_user.id) if current_user
    if @event.need_transportation?
      @total_transportation = @event.rsvps.collect{|r| r.transportation_ability || -1}.sum
    end
    @auth_event_owner = (@event.event_type == "Service" ? authorize(:serv) : authorize(:act))
  end

  def calendar
    month = (params[:month] || Time.now.month).to_i
    year = (params[:year] || Time.now.year).to_i
    @start_date = Date.new(year, month, 1) 
    @end_date = Date.new(year, month, 1).end_of_month
    @events = Event.with_permission(current_user).all.select { |event| (@start_date.to_time..@end_date.at_end_of_day).cover? event.start_time }.sort_by { |event| event.start_time }
    @event_types = Event.pluck(:event_type)
    #First Sunday
    @calendar_start_date = (@start_date.wday == 0) ? @start_date : @start_date.next_week.ago(8.days).to_date
    #Last Saturday
    @calendar_end_date = (@end_date.wday == 0) ? @end_date.since(6.days) : @end_date.next_week.ago(2.days).to_date

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'calendar'
      }
    end
  end

  # Lists all events with unconfirmed RSVPs with links to individual event
  # RSVPs page
  def confirm_rsvps_index
    redirect_to root_path unless authorize(:pres) or authorize(:vp)
    @role = params[:role] || :candidate
    types = ["Mandatory for Candidates", "Big Fun", "Fun", "Service"]

    @events = Event.current.find(:all, :joins => { :rsvps => {:user => :roles} }, :conditions => "(rsvps.confirmed IS NULL OR rsvps.confirmed = 'f') AND roles.id = #{Role.find_by_name(@role).id}").uniq
    @events.sort!{|x, y| x.start_time <=> y.end_time }.reverse!
  end

  # RSVP confirmation for an individual event
  def confirm_rsvps
    redirect_to root_path unless authorize(:pres) or authorize(:vp)
    @role = params[:role] || :candidate
    @event = Event.find(params[:id])
    @rsvps = @event.rsvps.includes(:user).sort_by { |rsvp| rsvp.user.full_name }
  end

  private
    def event_authorize
      @event_auth = comm_authorize
    end

    def event_params
      params.require(:event).permit(:title, :description, :location, :start_time, :end_time, :event_type,
                    :view_permission_roles, :rsvp_permission_roles, :max_rsvps, :need_transportation?)
    end
end
