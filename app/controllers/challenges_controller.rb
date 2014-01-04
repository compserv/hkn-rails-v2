class ChallengesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_challenge, only: [:update]
  before_filter :is_candidate?, only: [:index, :update]

  def is_candidate?
    if current_user.has_role? :candidate, MemberSemester.current
      redirect_to root_path, notice: "Oops, a candidate shouldn't be here"
    end
  end

  # GET /challenges
  def index
    my_challenges = Challenge.where(requester_id: current_user.id)
    @pending = my_challenges.where(confirmed: nil)
    @confirmed = my_challenges.where(confirmed: true)
    @rejected = my_challenges.where(rejected: true)
  end

  # POST /challenges
  def create
    officer = User.find_by_id(params[:officer_id]) || User.find_by_username(params[:officer])
    redirect_to candidate_portal_path, alert: "Please choose an officer or committee member" and return unless officer
    params[:challenge][:requester_id] = officer.id
    params[:challenge][:candidate_id] = current_user.id
    @challenge = Challenge.new(challenge_params)

    if @challenge.save
      redirect_to candidate_portal_path, notice: 'Challenge was successfully created.'
    else
      redirect_to candidate_portal_path, alert: "#{@challenge.errors.full_messages.to_s}"
    end
  end

  # PATCH/PUT /challenges/1
  def update
    if @challenge.update(params.permit(:confirmed, :rejected))
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
      params.require(:challenge).permit(:requester_id, :candidate_id, :confirmed, :rejected, :name, :description)
    end
end
