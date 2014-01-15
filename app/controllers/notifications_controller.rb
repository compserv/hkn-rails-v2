class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @notifications = []

    @notifications |= Challenge.where(requester_id: current_user.id, confirmed: nil) # this gets called every page reload. What a pain.

    @notifications.sort_by(&:updated_at)

    respond_to do |format|
      format.html { render :index, layout: false }
      format.json { render json: @notifications }
    end
  end

end
