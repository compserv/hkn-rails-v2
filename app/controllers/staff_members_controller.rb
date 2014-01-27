class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_csec!, except: [:show, :instructors]

  def instructors
    @category = params["instructors"].to_sym
    @eff_q = SurveyQuestion.find_by_keyword "#{@category.to_s}_eff".to_sym
    return redirect_to coursesurveys_path, notice: "Invalid category" unless @category && @eff_q
    @results = []

=begin
    StaffMember.where(id: CourseStaffMember.select(:staff_member_id).
        where(staff_role: @category, 
              id: SurveyQuestionResponse.select(:course_staff_member_id).
                                         where(survey_question_id: @eff_q.id).
                                         collect(&:course_staff_member_id)).
              collect(&:staff_member_id)).
        includes(course_staff_members: {course_offering: :course}).
        order(:last_name, :first_name).each do |i|
    @results << { instructor: i,
                  courses: i.course_staff_members.course_offerings.course.where('course_staff_members.staff_role = ? AND course_staff_members.staff_member_id = ?', @category, i.id),
                  rating: i.release_surveys ? i.survey_question_responses.where(survey_question_id: @eff_q.id).average(:rating) : nil
                  }
    end
=end


    # below works but does a lot of database queries, well so does above

    @staff = StaffMember.includes(:courses, :survey_question_responses).joins(:course_staff_members).
        where('course_staff_members.staff_role = ?', @category).
        joins(:survey_question_responses).
        where('survey_question_responses.survey_question_id = ?', @eff_q.id).
        order(:last_name, :first_name).
        each do |i|
          @results << { :instructor => i,
                        :courses    => i.courses.where('course_staff_members.staff_role = ? AND course_staff_members.staff_member_id = ?', @category, i.id),
                        :rating     => i.release_surveys ? i.survey_question_responses.where(survey_question_id: @eff_q.id).average(:rating) : nil
                      }
    end
  end

  # GET /staff_members
  def index
    @staff_members = StaffMember.all
  end

  # GET /staff_members/1
  def show
  end

  # GET /staff_members/new
  def new
    @staff_member = StaffMember.new
  end

  # GET /staff_members/1/edit
  def edit
  end

  # POST /staff_members
  def create
    @staff_member = StaffMember.new(staff_member_params)

    if @staff_member.save
      redirect_to @staff_member, notice: 'Staff member was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /staff_members/1
  def update
    if @staff_member.update(staff_member_params)
      redirect_to @staff_member, notice: 'Staff member was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /staff_members/1
  def destroy
    @staff_member.destroy
    redirect_to staff_members_url, notice: 'Staff member was successfully destroyed.'
  end

  def merge
    @instructors = [:id_0, :id_1].collect {|s| params[s].blank? ? nil : StaffMember.find(params[s])}
  end

  def merge_post_setup
    @instructors = [:id_0, :id_1].collect {|s| params[s].blank? ? nil : StaffMember.find(params[s])}
    redirect_to staff_members_merge_path(id_0: params[:id_0], id_1: params[:id_1]), notice: "Invalid IDs" and return unless @instructors.all?
    redirect_to staff_members_merge_path(id_0: params[:id_0], id_1: params[:id_1])
  end

  def merge_post_commit
    @instructors = [:id_0, :id_1].collect {|s| params[s].blank? ? nil : StaffMember.find(params[s])}
    redirect_to staff_members_merge_path(id_0: params[:id_0], id_1: params[:id_1]), notice: "Invalid IDs" unless @instructors.all?

    p = {}
    StaffMember.column_names.collect(&:downcase).collect(&:to_sym).each do |col|
      # params[col] is 0 or 1, indicating from which instructor to take the new attribute
      p[col] = @instructors[params[col].to_i].send(col) if params[col]
    end

    @instructor = StaffMember.new(p)

    begin
      StaffMember.transaction do
        puts "FUCK LIFE"
        raise unless @instructor.eat(@instructors)
      end
    rescue => e
      return redirect_to staff_members_merge_path(id_0: @instructors[0].id, id_1: @instructors[1].id), :notice => [e,@instructor.errors.inspect, @instructor].inspect
    end

    redirect_to @instructor, :notice => "This is the new instructor."
  end

  def autocomplete_staff_members_name
    render :json => StaffMember.all.map {|p| {:label => p.full_name_r, :id => p.id} }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff_member
      @staff_member = StaffMember.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def staff_member_params
      params.require(:staff_member).permit(:first_name, :last_name, :release_surveys, :picture, :title, :interests, :home_page, :office, :phone_number, :email)
    end
end
