class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_vp!

  # GET /announcements
  def index
    @announcements = Announcement.all
  end

  # GET /announcements/1
  def show
  end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements
  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.user = current_user

    if @announcement.save
      redirect_to @announcement, notice: 'Announcement was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /announcements/1
  def update
    if @announcement.update(announcement_params)
      redirect_to @announcement, notice: 'Announcement was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /announcements/1
  def destroy
    @announcement.destroy
    redirect_to announcements_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def announcement_params
      params.require(:announcement).permit(:title, :body)
    end
end
