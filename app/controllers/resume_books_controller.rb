class ResumeBooksController < ApplicationController
  before_action :set_resume_book, only: [:show, :edit, :update, :destroy, :download_pdf, :download_iso]
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


  # POST /resume_books
  def create
    @resume_book = ResumeBook.new(resume_book_params)

    @scratch_dir = Rails.root.join('private', Time.new.strftime("%Y%m%d%H%M%S%L"))
    @skeletons = Rails.root.join('private', 'template')
    raise "Failed to make scratch dir" unless system "mkdir #{@scratch_dir}"
    system "cp #{@skeletons}/hkn_emblem.png #{@scratch_dir}/"

    indrel_officers = Role.semester_filter(MemberSemester.current).position(:indrel).officers.all_users.sort(&:full_name) # for use in binding on indrel_letter
    resumes_to_use = Resume.where(included: true).where('file_updated_at >= ?', @resume_book.cutoff_date).includes(:user).all
    grouped_resumes = group_resumes(resumes_to_use)
    path_to_pdf = generate_pdf(grouped_resumes, indrel_officers)
    path_to_iso = generate_iso(grouped_resumes, path_to_pdf)
    save_for_paperclip(path_to_pdf, 'application/pdf')
    save_for_paperclip(path_to_iso, 'application/octet-stream')

    raise "Failed to kill scratch dir" unless system "rm -rf #{@scratch_dir}" # clean up

    @resume_book.title = MemberSemester.current.name
    if @resume_book.save
      redirect_to @resume_book, notice: 'Resume book was successfully created.'
    else
      render action: 'new'
    end
  end

  def generate_pdf(resumes, indrel_officers)
    sorted_yrs = sorted_years(resumes)
    pdf_paths = ["#{@skeletons}/cover.pdf"]
    pdf_paths << process_tex_template("#{@skeletons}/indrel_letter.tex.erb", binding)
    if sorted_yrs != [] # gracefully dodge if there are no resumes
      pdf_paths << process_tex_template("#{@skeletons}/table_of_contents.tex.erb", binding)
    end
    details = []
    sorted_yrs.each do |year|
      details << year.to_s + ": " + resumes[year].count.to_s
      pdf_paths << section_cover_page(year)
      resumes[year].each do |resume|
        pdf_paths << resume.file.path
      end
    end
    @resume_book.details = details.join(' ')
    concatenate_pdfs(pdf_paths, "#{@scratch_dir}/temp_resume_book.pdf") # creates single pdf from all paths
  end

  def generate_iso(resumes_to_use, res_book_pdf)
    # TODO there's some really shady stuff going on here..
    #      use Ruby libs to improve security
    @gen_root = Rails.root.join('private', 'template', 'ResumeBookISO')
    dir_name_fn = lambda {|year| year == :grads ? "grads" : year.to_s }
    iso_dir = "#{@scratch_dir}/ResumeBookISO"
    raise "Failed to copy ISO dir" unless system "cp -R #{@gen_root} #{iso_dir}"
    system "sed \"s/SEMESTER/#{MemberSemester.current.name}/g\" #{iso_dir}/Welcome.html > #{iso_dir}/Welcome.html.tmp"
    system "mv #{iso_dir}/Welcome.html.tmp #{iso_dir}/Welcome.html"
    system "mkdir #{iso_dir}/Resumes"
    resumes_to_use.each_key do |year|
      year_dir_name = "#{iso_dir}/Resumes/#{dir_name_fn.call(year)}"
      system "mkdir #{year_dir_name}"
      resumes_to_use[year].each do |resume|
        system "cp #{resume.file.path} \"#{year_dir_name}/#{resume.user.last_name}, #{resume.user.first_name}.pdf\""
      end
    end
    system "cp #{res_book_pdf} #{iso_dir}/HKNResumeBook.pdf"
    raise "Filed to genisoimage" unless system "hdiutil makehybrid -iso -joliet -o #{@scratch_dir}/HKNResumeBook.iso #{iso_dir}"
    #raise "Filed to genisoimage" unless system "genisoimage -V 'HKN Resume Book' -o #{@scratch_dir}/HKNResumeBook.iso -R -J #{iso_dir}"
    "#{@scratch_dir}/HKNResumeBook.iso"
  end

  def concatenate_pdfs(pdf_file_list, output_file_name)
    concat_cmd = "pdftk #{pdf_file_list.join(' ')} cat output #{output_file_name}"
    logger.error "Failed to concat pdfs (#{concat_cmd})" unless system concat_cmd
    output_file_name
  end

  def save_for_paperclip(path, type)
    template = File.read(path) # grab the created pdf, going to save w/ paperclip

    file = StringIO.new(template) # mimic a real upload file for paperclip
    file.class.class_eval { attr_accessor :original_filename, :content_type } # add attr's that paperclip needs
    file.content_type = type
    if type == "application/pdf"
      file.original_filename = "Resume_Book.pdf"
      @resume_book.pdf = file
    else
      file.original_filename = "Resume_Book.iso"
      @resume_book.iso = file
    end
  end

  # year will be a year i.e. 2011 or :grads
  def section_cover_page(year)
    do_erb("#{@skeletons}/section_title.tex.erb", "#{@scratch_dir}/#{year.to_s}title.tex", binding)
    do_tex("#{@scratch_dir}","#{year.to_s}title.tex")
    "#{@scratch_dir}/#{year.to_s}title.pdf"
  end

  def group_resumes(unsorted_resumes)
    resumes = Hash.new
    graduating_class = MemberSemester.current.year + (MemberSemester.current.season == "Fall" ? 1 : 0) # 2014 Fall means class of 2014 has graduated, have to add an extra 1

    unsorted_resumes.each do |resume|
      # append to correct array
      if resume.graduation_year < graduating_class
        resumes[:grads] ||= []
      else
        resumes[resume.graduation_year] ||= []
      end << resume
    end

    # Now sort the resumes in each group by Last Name
    resumes.values.each { |a| a.sort_by! {|r| r.user.last_name} }
    return resumes
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

  def do_erb(input_file_name, output_file_name, bindings) # evaluates a .?.erb file into a .?, saves into new location
    template_string = File.new(input_file_name).readlines.join("")
    template = ERB.new(template_string)
    f = File.new(output_file_name, "w")
    f.write(template.result(bindings))
    f.close
  end
  
  def do_tex(directory, file_name) # converts .tex to a .pdf in same directory
    Dir.chdir(directory) do  # move to directory
      raise "Failed to pdflatex #{file_name}" unless system "pdflatex #{file_name}" # execute the pdflatex command on the file
    end
  end

  # get the keys of resumes hash in correct order so we have increasing years
  # in resume book
  def sorted_years(resumes)
    grad_flag = resumes.keys.include?(:grads)
    sorted_yrs = resumes.keys.reject{|x| x.class == Symbol}
    sorted_yrs.sort!
    sorted_yrs << :grads if grad_flag
    sorted_yrs
  end

  def nice_class_name(year)
    if year == :grads
      "Graduates"
    else
      "Class of #{year}"
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

  def download_pdf
    send_file @resume_book.pdf.path, type: @resume_book.pdf_content_type,
                                 filename: @resume_book.pdf_file_name,
                                 disposition: 'inline' # loads file in browser for now.
  end

  def download_iso
    send_file @resume_book.iso.path, :type => 'application/octet-stream', filename: @resume_book.iso_file_name, :x_sendfile => true
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
