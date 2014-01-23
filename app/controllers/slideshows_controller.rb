class SlideshowsController < ApplicationController
  before_action :slideshow_auth, except: [:index, :show]

  def index
    @slideshows = Slideshow.includes(:member_semester)
    @bridge_auth = authorize :bridge
  end

  def create
    @slideshow = Slideshow.new(slideshow_params)

    if @slideshow.save
      redirect_to @slideshow, notice: "Slideshow uploaded"
    else
      render :new
    end

  end

  def new
    @slideshow = Slideshow.new
  end

  def destroy
    @slideshow.destroy
    redirect_to :index
  end

  def show
    @slideshow = Slideshow.find(params[:id])
  end

  private
  def slideshow_auth
    authenticate! :bridge
  end
  
  def slideshow_params
    params.require(:slideshow).permit(:member_semester_id, :slideshow)
  end
end
