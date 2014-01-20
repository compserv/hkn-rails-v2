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
    debugger
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
