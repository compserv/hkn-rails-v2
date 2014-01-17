class EventsController < ApplicationController
  before_filter :event_authorize
  before_filter :comm_authorize!, except: [:index, :show, :calendar]

  def index
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

    category = params[:category] || 'all'
    event_finder = Event.with_permission(current_user)

    if category == 'past'
      event_finder = event_finder.past
      @heading = "Past Events"
    elsif category == 'future'
      event_finder = event_finder.upcoming
      @heading = "Upcoming Events"
    else
      @heading = "All Events"
    end
    if event_filter != "none"
      event_finder = event_finder.where('lower(event_type) = ?', event_filter)
    end

    # Maintains start_time as secondary sort column
    ord = "#{order} #{sort_direction}, start_time #{sort_direction}"
    options = { :page => params[:page], :per_page => 20 }
    @events = event_finder.order(ord).paginate options

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

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :new }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :edit }
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
      @event = Event.with_permission(current_user).includes(rsvps: :user).find(params[:id])
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
    @events = Event.with_permission(current_user).select { |event| (@start_date.to_time..@end_date.at_end_of_day).cover? event.start_time }.sort_by { |event| event.start_time }
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
    authorize(:pres) || authenticate_vp!
    @role = params[:role] || :candidates
    if @role.to_sym == :candidates
      users = MemberSemester.current.candidates
    else
      @role = :members
      users = Role.members.all_users
    end
    @events = Event.current.joins(rsvps: :user).where("(rsvps.confirmed IS NULL OR rsvps.confirmed = 'f') AND users.id in (?)", users).uniq
    @events.sort!{|x, y| x.start_time <=> y.end_time }.reverse!
  end

  # RSVP confirmation for an individual event
  def confirm_rsvps
    authorize(:pres) || authenticate_vp!
    @role = params[:role] || :candidates
    if @role.to_sym == :candidates
      users = MemberSemester.current.candidates
    else
      @role = :members
      users = Role.members.all_users
    end
    @event = Event.find(params[:id])
    @rsvps = @event.rsvps.joins(:user).where("users.id in (?)", users).sort_by { |rsvp| rsvp.user.full_name }
  end

  def leaderboard
    @semester = params[:semester] ? MemberSemester.find_by_id(params[:semester]) : MemberSemester.current
    @users = Role.members.semester_filter(@semester).all_users
    @users_array = []
    #moar_people = [ 'eunjian' ].collect{|u|Person.find_by_username(u)}   # TODO remove when we have leaderboard opt-in
    @users.each do |user|
      # Makeshift data structure
      events = user.rsvps.where(confirmed: 't').joins(:event).where("events.start_time > ? AND events.start_time < ?", @semester.start_time, @semester.end_time)
      @users_array << {
        :user => user, 
        :total => events.count,
        :events => events
      }
    end

    @users_array.each do |entry|
      entry[:big_fun] = entry[:events].where("events.event_type = ? ", "Big Fun").count
      entry[:fun] = entry[:events].where("events.event_type = ? ", "Fun").count
      entry[:service] = entry[:events].where("events.event_type = ? ", "Service").count
      entry[:score] = 2*entry[:big_fun] + entry[:fun] + 3*entry[:service]
    end

    @users_array.sort!{|a,b| a[:score] <=> b[:score]}
    @users_array.reverse!
    rank = 0
    last_num = -1
    incr = 1
    @users_array.each do |entry|
      if last_num != entry[:score]
        rank += incr
        last_num = entry[:score]
        incr = 0
      end
      entry[:rank] = rank
      incr += 1
    end
  end

  private
    def event_authorize
      @event_auth = comm_authorize
    end

    def event_params
      params.require(:event).permit(:title, :description, :location, :start_time, :end_time, :event_type,
                    :view_permission_roles, :rsvp_permission_roles, :max_rsvps, :need_transportation)
    end
end
