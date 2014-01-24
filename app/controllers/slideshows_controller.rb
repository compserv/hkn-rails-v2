class SlideshowsController < ApplicationController
  before_action :authenticate_bridge!, except: [:index]

  def index
    @slideshows = Slideshow.includes(:member_semester).order(created_at: :desc)
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
    Slideshow.find(params[:id]).destroy
    redirect_to slideshows_path 
  end

  def show
    @slideshow = Slideshow.find(params[:id])
  end

  private
  def slideshow_params
    params.require(:slideshow).permit(:member_semester_id, :slideshow)
  end
end
