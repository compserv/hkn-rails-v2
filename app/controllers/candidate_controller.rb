class CandidateController < ApplicationController

  def portal
    @challenges = Challenge.all
  end

  def quiz
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
