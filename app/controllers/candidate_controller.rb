class CandidateController < ApplicationController

  def portal
    @challenges = Challenge.all
    @challenge = Challenge.new
    render 'candidate_index'
  end

end
