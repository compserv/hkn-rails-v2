class ResumeBooksController < ApplicationController
  before_action :set_resume_book, only: [:show, :edit, :update, :destroy, :download_pdf]
  before_filter :authenticate_indrel!, :except => [:download_pdf]

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

  def do_erb(input_file_name, output_file_name, bindings)
    template_string = File.new(input_file_name).readlines.join("")
    template = ERB.new(template_string)
    f = File.new(output_file_name, "w")
    f.write(template.result(bindings))
    f.close
  end
  
  def do_tex(directory, file_name)
    Dir.chdir(directory) do  # move to directory
      raise "Failed to pdflatex #{file_name}" unless system "pdflatex #{file_name}" # execute the pdflatex command on the file
    end
  end

  def process_tex_template(input_file_name, bindings)
    # @scratch_dir is a directory created before this function should be called
    file_base_name_tex_erb = File.basename(input_file_name)
    file_base_name_tex = file_base_name_tex_erb[0..-5] # strip off .erb
    file_base_name_pdf = file_base_name_tex[0..-5] + ".pdf" # strip off .tex.erb and add .pdf
    do_erb(input_file_name, "#{@scratch_dir}/#{file_base_name_tex}", bindings) # convert the .tex.erb into a .tex file
    do_tex("#{@scratch_dir}", file_base_name_tex) # convert the .tex to a .pdf
    "#{@scratch_dir}/#{file_base_name_pdf}" # return the path to the pdf
  end

  # POST /resume_books
  def create
    @resume_book = ResumeBook.new(resume_book_params)

    indrel_officers = Role.semester_filter(MemberSemester.current).position(:indrel).officers.all_users
    time = Time.new.strftime("%Y%m%d%H%M%S%L")
    @scratch_dir = Rails.root.join('private', 'scratch', time)
    raise "Failed to make scratch dir" unless system "mkdir #{@scratch_dir}"

    pdf_paths = [Rails.root.join('private', 'cover.pdf'), process_tex_template(Rails.root.join('private', 'indrel_letter.tex.erb'), binding)]

    resumes_to_use = Resume.where(included: true).where('file_updated_at >= ?', @resume_book.cutoff_date).includes(:user).all
    resumes_to_use.each do |resume|
      pdf_paths << resume.file.path
    end

    merge_pdfs(pdf_paths, Rails.root.join('private', 'temp_resume_book.pdf')) # creates pdf as /private/temp_resume_book.pdf
    template = File.read(Rails.root.join('private', 'temp_resume_book.pdf'))

    file = StringIO.new(template) # mimic a real upload file for paperclip
    file.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
    file.original_filename = "resume_book.pdf"
    file.content_type = "application/pdf"

    #now just use the file object to save to the Paperclip association.
    @resume_book.pdf = file
    File.delete(Rails.root.join('private', 'temp_resume_book.pdf')) # clean up
    #raise "Failed to kill scratch dir" unless system "rm -rf #{@scratch_dir}"

    @resume_book.title = "HI"
    @resume_book.details = "NONE"
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

  def merge_pdfs(pdf_paths, destination)
    
    first_pdf_path = pdf_paths.delete_at(0)
    
    a = Prawn::Document.generate(destination, :template => first_pdf_path) do |pdf|
      
      pdf_paths.each do |pdf_path|
        pdf.go_to_page(pdf.page_count)
        
        template_page_count = count_pdf_pages(pdf_path)
        (1..template_page_count).each do |template_page_number|
          pdf.start_new_page(:template => pdf_path, :template_page => template_page_number)
        end
      end
      
    end
    
  end
    
  def count_pdf_pages(pdf_file_path)
    pdf = Prawn::Document.new(:template => pdf_file_path)
    pdf.page_count
  end

  def download_pdf
    send_file @resume_book.pdf.path, type: @resume_book.pdf_content_type,
                                 filename: @resume_book.pdf_file_name,
                                 disposition: 'inline' # loads file in browser for now.
  end

  # Missing gives the emails of officers and current candidates who are missing
  # a resume book so indrel can bug them.
  def missing
    @cutoff_date = params[:date] ? params[:date].map{|k,v| v}.join("-").to_date : Date.today

    officers = Role.semester_filter(MemberSemester.current).officers.all_users_resumes
    candidates = Role.semester_filter(MemberSemester.current).candidates.all_users_resumes

    @officers_without_resumes, @candidates_without_resumes = [officers,candidates].collect do |ppl|
      ppl.reject { |p| p.resume && p.resume.file_updated_at.to_date >= @cutoff_date }
    end

    @users_in_book = Resume.where("file_updated_at >= ?", @cutoff_date).includes(:user).collect(&:user).sort_by(&:full_name)

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
