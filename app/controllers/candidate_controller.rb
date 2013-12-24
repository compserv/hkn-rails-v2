class CandidateController < ApplicationController

  def portal
    @challenges = Challenge.all
  end

  def autocomplete_officer_name
    if params[:term]
      @users = User.where('username LIKE ?', "#{params[:term]}%")
    else
      @users = User.limit(10)
    end
    render :json => @users.pluck(:username).to_json
  end
end
