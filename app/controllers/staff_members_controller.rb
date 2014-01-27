class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_csec!, except: [:show]

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