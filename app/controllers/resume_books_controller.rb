class ResumeBooksController < ApplicationController
  before_action :set_resume_book, only: [:show, :edit, :update, :destroy]

  # GET /resume_books
  def index
    @resume_books = ResumeBook.all
  end

  # GET /resume_books/1
  def show
  end

  # GET /resume_books/new
  def new
    @resume_book = ResumeBook.new
  end

  # GET /resume_books/1/edit
  def edit
  end

  # POST /resume_books
  def create
    debugger
    @resume_book = ResumeBook.new(resume_book_params)
    resumes = Resume.all
    #resumes.each do |x|


    if @resume_book.save
      redirect_to @resume_book, notice: 'Resume book was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /resume_books/1
  def update
    if @resume_book.update(resume_book_params)
      redirect_to @resume_book, notice: 'Resume book was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /resume_books/1
  def destroy
    @resume_book.destroy
    redirect_to resume_books_url, notice: 'Resume book was successfully destroyed.'
  end

  def download
    @resume = ResumeBook.find(params[:id])
    send_file @resume.file.path, type: @resume.file_content_type,
                                 filename: @resume.file_file_name,
                                 disposition: 'inline' # loads file in browser for now.
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume_book
      @resume_book = ResumeBook.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def resume_book_params
      params.require(:resume_book).permit(:title, :remarks, :details, :cutoff_date)
    end
end
