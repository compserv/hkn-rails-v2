class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:update]
  #before_action :authenticate_officer, only: [:index, :update]

  # GET /challenges
  def index
    @pending = Challenge.where(confirmed: nil)
    @confirmed = Challenge.where(confirmed: true)
    @rejected = Challenge.where(rejected: true)
  end

  # POST /challenges
  def create
    params[:requester_id] = User.find_by_username(params[:officer]).id
    #params[:candidate_id] = current_user.id
    @challenge = Challenge.new(challenge_params)

    if @challenge.save
      redirect_to candidate_portal_path, notice: 'Challenge was successfully created.'
    else
      redirect_to candidate_portal_path, alert: "#{@challenge.errors.full_messages.to_s}"
    end
  end

  # PATCH/PUT /challenges/1
  def update
    if @challenge.update(challenge_params)
      redirect_to challenges_path, notice: 'Challenge was successfully updated.'
    else
      redirect_to challenges_path, alert: "#{@challenge.errors.full_messages.to_s}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_challenge
      @challenge = Challenge.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def challenge_params
      params.permit(:requester_id, :candidate_id, :confirmed, :rejected, :name, :description)
    end
end
