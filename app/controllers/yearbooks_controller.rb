class YearbooksController < ApplicationController
  before_action :authenticate_bridge!, except: [:index, :show]

  def index
    @yearbooks = Yearbook.order(year: :desc)
    @bridge_auth = authorize :bridge
  end

  def new
    @yearbook = Yearbook.new
  end

  def create
    @yearbook = Yearbook.new(yearbook_params)
    if @yearbook.save
      redirect_to @yearbook, notice: "Yearbook uploaded"
    else
      render :new
    end
  end

  def show
    @yearbook = Yearbook.find(params[:id])
  end

  def destroy
    Yearbook.find(params[:id]).destroy
    redirect_to yearbooks_path
  end

  private
  
  def yearbook_params
    params.require(:yearbook).permit(:year, :pdf)
  end

end
