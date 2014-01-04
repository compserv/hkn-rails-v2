class CandidateController < ApplicationController
  before_filter :authenticate_user!
  before_filter :is_candidate?

  def is_candidate?
    unless current_user.has_role? :candidate, MemberSemester.current
      flash[:notice] = "You're not a candidate, so this information may not apply to you"
    end
  end

  def portal
    @challenges = Challenge.all
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
    render :json => Role.members.includes(:users).all_users.map {|p| {:label => p.full_name, :id => p.id} }
  end
end
