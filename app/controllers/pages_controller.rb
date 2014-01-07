class PagesController < ApplicationController
  #tocache = [:coursesurveys_how_to, :coursesurveys_info_profs, :coursesurveys_ferpa, :contact, :comingsoon, :yearbook, :slideshow]
  #tocache.each {|a| caches_action a, :layout => false}

  def home
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

  def cmembers
    # Get the most recent semester
    @semester = params[:semester] ? MemberSemester.find_by_id(params[:semester]) : MemberSemester.current
    # Using the semester, get the committeeships, sorted by committee
    cships = Committeeship.semester(@semester).cmembers.sort_by do |c|
      c.committee
    end.ordered_group_by(&:committee)
    # Group cships by committee
    @committeeships = cships.group_by do |c_ary|
      :committees
    end
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
