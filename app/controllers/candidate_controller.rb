class CandidateController < ApplicationController
  before_filter :authenticate_user!
  before_filter :is_candidate?

  def is_candidate?
    unless currently_candidate?
      flash[:notice] = "You're not a candidate, so this information may not apply to you"
    end
  end

  def portal
    req = Hash.new { |h,k| 0 }
    req["Mandatory for Candidates"] = 3
    req["Fun"] = 3
    req["Big Fun"] = 1
    req["Service"] = 2
    @my_events = current_user.events.group_by(&:event_type)
    @my_confirmed_events = current_user.events.joins(:rsvps).where('rsvps.confirmed = ?', 't').group_by(&:event_type)
    @status = {}
    req.each do |x, y|
      @my_events[x] ||= []
      @my_confirmed_events[x] ||= []
      @status[x] = (@my_confirmed_events[x].count >= y)
    end
    @events = Event.with_permission(current_user).where('end_time >= ? AND end_time <= ?', Time.now, Time.now + 7.days).order(:start_time)
    @challenges = Challenge.where(candidate_id: current_user.id)
    @announcements = Announcement.all.limit(10)
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
    redirect_to candidate_portal_path, notice: "Your quiz responses have been recorded."
  end

  def autocomplete_officer_name
    render :json => Role.members.all_users.map {|p| {:label => p.full_name, :id => p.id} }
  end
end
