class EventsController < ApplicationController
  before_filter :event_authorize

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
  end

  def new
  end

  def create
  end

  def update
  end

  def destroy
  end

  def edit
  end

  def show
  end

  def calendar
    month = (params[:month] || Time.now.month)
    year = (params[:year] || Time.now.year)
    @start_date = Date.new(year, month, 1) 
    @end_date = Date.new(year, month, 1).end_of_month
    @events = Event.with_permission(current_user).all.select { |event| (@start_date.to_time..@end_date.at_end_of_day).cover? event.start_time }
    @event_types = Event.pluck(:event_type)
    #First Sunday
    @calendar_start_date = (@start_date.wday == 0) ? @start_date : @start_date.next_week.ago(8.days).to_date
    #Last Saturday
    @calendar_end_date = (@end_date.wday == 0) ? @end_date.since(6.days) : @end_date.next_week.ago(2.days).to_date
  end

  private
    def event_authorize
      @event_auth = comm_authorize
    end
end
