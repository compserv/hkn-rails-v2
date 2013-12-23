class CandidateController < ApplicationController

  def portal
  	@challenges = Challenge.all
  end

end
