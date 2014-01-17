class PagesController < ApplicationController
  #tocache = [:coursesurveys_how_to, :coursesurveys_info_profs, :coursesurveys_ferpa, :contact, :comingsoon, :yearbook, :slideshow]
  #tocache.each {|a| caches_action a, :layout => false}

  def home
    @events = Event.with_permission(current_user).where('end_time >= ? AND end_time <= ?', Time.now, Time.now + 7.days).order(:start_time)
    @show_searcharea = true
    #prop = Property.get_or_create
    #@tutoring_enabled = prop.tutoring_enabled
    #@hours = prop.tutoring_start .. prop.tutoring_end
    time = Time.now
    time = time.tomorrow if time.hour > 16#prop.tutoring_end
    time = time.next_week unless (1..5).include? time.wday
    @day = time.wday
    @tutor_title = "#{time.strftime("%A")}'s Tutoring Schedule"
    #if @tutoring_enabled
    #  @course_mapping = {}
    #  @slots = Slot.includes(:tutors).where(:wday => time.wday)
    #else
      @tutoring_message = "HKN is on break for the holidays"#prop.tutoring_message
    #end
  end

  def coursesurveys_how_to
  end

  def coursesurveys_info_profs
  end

  def coursesurveys_ferpa
  end

  def contact
  end

  def comingsoon
  end

  def yearbook
  end

  def slideshow
  end

  def committee_members
    # Get the most recent semester
    @semester = params[:semester] ? MemberSemester.find_by_id(params[:semester]) : MemberSemester.current
    # Using the semester, get the committeeships, sorted by committee
    cships = Role.semester_filter(@semester).committee_members.includes(:users).sort_by(&:name)
    # Group cships by committee
    @committeeships = cships.group_by{ :committees }
    # If @committeeships[:committees] is null, make it empty
    @committeeships[:committees] ||= {}
  end

  def officers
    @semester = params[:semester] ? MemberSemester.find_by_id(params[:semester]) : MemberSemester.current

    cships = Role.semester_filter(@semester).officers.includes(:users).sort_by do |c|
      if c.exec?  # exec position is in a certain order.
        Role::Execs.find_index(c.name).to_s
      else        # normal committee is alphabetical
        c.name
      end
    end

    @committeeships = cships.group_by do |r|  # r is a role
      Role::Execs.include?(r.name)  ?  :execs  :  :committees
    end

    [:execs, :committees].each {|s| @committeeships[s] ||= {}}   # Null Pointer Expceptions are bad
  end
end
