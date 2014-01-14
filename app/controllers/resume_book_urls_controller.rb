class ResumeBookUrlsController < ApplicationController
  before_action :set_resume_book_url, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_indrel!

  # GET /resume_book_urls
  def index
    @resume_book_urls = ResumeBookUrl.all.sort_by(&:created_at)
  end

  # GET /resume_book_urls/1
  def show
  end

  # GET /resume_book_urls/new
  def new
    @resume_book_url = ResumeBookUrl.new
    @resume_book_url.password = SecureRandom.urlsafe_base64(100)
  end

  # GET /resume_book_urls/1/edit
  def edit
  end

  # POST /resume_book_urls
  def create
    @resume_book_url = ResumeBookUrl.new(resume_book_url_params)
    @resume_book_url.download_count = 0

    if @resume_book_url.save
      redirect_to @resume_book_url, notice: 'Resume book url was successfully created.'
    else
      render action: 'new' 
    end
  end

  # PATCH/PUT /resume_book_urls/1
  def update
    if @resume_book_url.update(resume_book_url_params)
      redirect_to @resume_book_url, notice: 'Resume book url was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /resume_book_urls/1
  # DELETE /resume_book_urls/1.json
  def destroy
    @resume_book_url.destroy
    respond_to do |format|
      format.html { redirect_to resume_book_urls_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume_book_url
      @resume_book_url = ResumeBookUrl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resume_book_url_params
      params.require(:resume_book_url).permit(:resume_book_id, :expiration_date, :feedback, :password, :download_count, :company, :name, :email, :transaction_id)
    end
end
