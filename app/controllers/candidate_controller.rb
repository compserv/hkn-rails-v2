class CandidateController < ApplicationController
  before_filter :authenticate_user!
  before_filter :is_candidate?

  def is_candidate?
    unless currently_candidate?
      flash.now[:alert_cand] = "You're not a candidate, so this information may not apply to you"
    end
  end

  def portal
    @events = Event.with_permission(current_user).where('end_time >= ? AND end_time <= ?', Time.now, Time.now + 7.days).order(:start_time)
    @challenges = Challenge.where(candidate_id: current_user.id)
    @announcements = Announcement.all.limit(10)
    set_up_status_and_my_events
    set_up_done
  end

  def set_up_status_and_my_events
    req = Hash.new { |h,k| 0 }
    req["Mandatory for Candidates"] = 3
    req["Fun"] = 3
    req["Big Fun"] = 1
    req["Service"] = 2
    @my_events = current_user.events.group_by(&:event_type)
    @my_confirmed_events = current_user.events.joins(:rsvps).where('rsvps.confirmed = ?', 't').group_by(&:event_type)
    @status = {}
    req.each do |event_type, count_required|
      @my_events[event_type] ||= []
      @my_confirmed_events[event_type] ||= [] # prevent nil exceptions
      @status[event_type] = (@my_confirmed_events[event_type].count >= count_required)
    end
  end

  def set_up_done
    @done = Hash.new(false)
    @done["events"] = !@status.has_value?(false)
    @done["challenges"] = @challenges.where(confirmed: true).count >= 5
    @done["resume"] = !current_user.resume.nil?
    @done["quiz"] = !current_user.candidate_quiz.nil?
    @done["forms"] = @done["resume"] and @done["quiz"]
  end

  def quiz
    @quiz_resp = Hash.new('')
    if !current_user.candidate_quiz
      CandidateQuiz.create(user: current_user)
    else
      quiz_resp = current_user.candidate_quiz.quiz_responses
      for resp in quiz_resp
        @quiz_resp[('q' << resp.quiz_question_id.to_s).to_sym] = resp.response
      end
    end
  end

  def submit_quiz
    quiz_responses = current_user.candidate_quiz.quiz_responses
    params.each do |key, value|
      if key.match(/^q/) #Starts with "q", is a quiz response
        old_answer = quiz_responses.select { |resp| ('q' << resp.quiz_question_id.to_s).to_sym == key.to_sym }.first
        if old_answer
          old_answer.response = value.to_s
          old_answer.save
        else
          quiz_responses.create(quiz_question_id: Integer(key.to_s[1..-1]),
                                response: value.to_s)
        end
      end
    end
    current_user.candidate_quiz.grade
    redirect_to candidate_portal_path, notice: "Your quiz responses have been recorded."
  end

  def application
    @app_details = {
      committee_prefs: current_user.committee_preferences.blank? ? committee_defaults : current_user.committee_preferences.split(' '),
      local_address: current_user.local_address,
      perm_address: current_user.perm_address,
      phone: current_user.phone_number,
      graduation_semester: current_user.graduation_semester,
      release: !current_user.private,
      suggestion: current_user.suggestion
    }
  end

  def submit_app
    redirect_to candidate_application_path, notice: "Your application has invalid committees listed. Please notify compserv@hkn." unless committees_must_be_valid(params[:committee_prefs])
    to_update = {
      committee_preferences: params[:committee_prefs],
      suggestion: params[:suggestion],
      phone_number: params[:phone],
      local_address: params[:local_address],
      perm_address: params[:perm_address],
      graduation_semester: params[:grad_sem],
      :private => params[:release].nil?
    }
    current_user.update_attributes(to_update)
    redirect_to candidate_application_path, notice: "Your application has been saved."

  end

  def committees_must_be_valid(committee_preferences)
    defaults = committee_defaults.collect {|c| c.downcase}
    if committee_preferences.blank?
      # nil is a valid committee
      return true
    end
    committee_preferences.split(' ').each do |comm|
      if not defaults.include?(comm.downcase)
        return false
      end
    end
    return true
  end

  def committee_defaults
    defaults = ["Activities", "Bridge", "CompServ", "Service", "Indrel", "StudRel", "Tutoring"]
  end

  def autocomplete_officer_name
    render :json => Role.members.all_users.map {|p| {:label => p.full_name, :id => p.id} }
  end
end
