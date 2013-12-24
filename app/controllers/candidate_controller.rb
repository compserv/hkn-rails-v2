class CandidateController < ApplicationController

  def portal
    @challenges = Challenge.all
  end

  def autocomplete_officer_name
    if params[:term]
      @users = User.where('username LIKE ?', "#{params[:term]}%")
    else
      @users = User.all
    end
    array = []
    @users.each do |user|
      array << user.username
    end
    render :json => array.to_json
  end
end
