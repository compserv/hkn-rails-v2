class YearbooksController < ApplicationController
  before_action :yearbook_auth, except: [:index, :show]

  def index
    @yearbooks = Yearbook.all
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
    @yearbook.destroy
    redirect_to :index
  end

  private
  def yearbook_auth 
    authenticate! :bridge
  end
  
  def yearbook_params
    params.require(:yearbook).permit(:year, :pdf)
  end

end
