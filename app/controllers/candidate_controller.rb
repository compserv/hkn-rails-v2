class CandidateController < ApplicationController
  before_filter :is_candidate?

  def is_candidate?
    if current_user
      if !current_user.has_role? :candidate
        flash[:notice] = "You're not a candidate, so this information may not apply to you"
      end
      return true
    else
      flash[:notice] = "You must be logged in to view that page."
      redirect_to "/"
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
        @quiz_resp[('q' << resp.id.to_s).to_sym] = resp.response
      end
    end
  end

  def submit_quiz
    params.each do |key, value|
      if key.match(/^q/) #Starts with "q", is a quiz response
        quiz_responses = current_user.candidate_quiz.quiz_responses
        old_answer = quiz_responses.select { |resp| ('q' << resp.quiz_question_id.to_s).to_sym == key }.first
        if old_answer
          old_answer.response = value.to_s
          old_answer.save
        else 
          quiz_responses.create(quiz_question_id: Integer(key.to_s[1..-1]),
                                response: value.to_s)
        end
      end
    end
    flash[:notice] = "Your quiz responses have been recorded."
    redirect_to :back
  end

  def autocomplete_officer_name
    if params[:term]
      @users = User.where('username LIKE ?', "#{params[:term]}%").limit(10)
    else
      @users = User.limit(10)
    end
    render :json => @users.pluck(:username).to_json
  end
end
