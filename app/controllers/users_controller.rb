require 'will_paginate/array'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :approve, :roles, :alter_roles]
  before_filter :authenticate_user!

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
    unless @user.id == current_user.id || authorize(:superuser)
      redirect_to edit_user_path(current_user), notice: "Oops you don't have permissions to edit others" and return
    end

    @mobile_carriers = MobileCarrier.all
  end

  # PATCH/PUT /users/1
  def update
    # Permissions
    unless @user == current_user || authorize(:superuser)
      redirect_to edit_user_path(current_user), alert: "Could not update settings." and return
    end

    # Superusers can edit anyone
    if authorize(:superuser)
      path = edit_user_path(@user)
    else
      path = edit_user_path(current_user)
    end

    # Verify password
    unless params[:password] && current_user.valid_password?(params[:password][:current])
      redirect_to path, notice: "You must enter in your current password to make any changes." and return
    end

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    # DO IT
    if @user.update_attributes(user_params)
      redirect_to path, notice: 'Settings successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    unless @user.id == current_user.id || authorize(:superuser) || (authorize(:vp) and @user.approved == false)
      redirect_to edit_user_path(current_user), notice: "You can't delete #{@user.username}" and return
    end
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def list
    params[:category] ||= "all"
    params["sort"] ||= "first_name"
    params["sort_direction"] ||= "up"
    sort_direction = case params["sort_direction"]
                     when "up" then "ASC"
                     when "down" then "DESC"
                     else "ASC"
                     end

    # Can view a group if:
    #   (1) you're a superuser
    #   (3) you're in it
    #   (2) it's a public group               (  vvv      one of these      vvv        )    v combines public groups w/ roles of current_user
    unless authenticate_superuser or (%w[officers committee_members members candidates all] | current_user.roles.collect(&:name)).include?(params[:category])
      flash[:notice] = "No category named #{params[:category]}. Displaying all people."
      params[:category] = "all"
    end

    @search_opts = params # for use in #sort_link in application_helper

    if %w[officers committee_members candidates].include? params[:category]
      cond = ["role_type = ? AND resource_id = ?", params[:category].singularize, MemberSemester.current.id] # autos to current semester
    elsif params[:category] == "members"
      cond = ["role_type = 'officer' OR role_type = 'committee_member' OR role_type = 'member'"]
    elsif params[:category] != "all"
      cond = ["name = ?", params[:category]] # searching for other things...e.g. indrel
    end

    opts = { page: params[:page], per_page: params[:per_page] || 20 }
    ord = "users." + params["sort"] + " " + sort_direction
    joinstr = 'INNER JOIN "users_roles" ON "users_roles"."user_id" = "users"."id" INNER JOIN "roles" ON "roles"."id" = "users_roles"."role_id"'

    user_selector = User.uniq(:id)
    if authenticate_vp and params[:approved] == 'false'
      @users = user_selector.where(approved: false).paginate opts
    else
      @users = user_selector.order(ord).joins(joinstr).where(cond).paginate opts
    end

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'list_results'
      }
    end
  end

  def approve
    authenticate_vp! # current user must at least be vp to approve
    if @user.update(approved: true)
      @user.add_position_for_semester_and_role_type(:candidate, MemberSemester.current, :candidate)
      flash[:notice] = "Successfully approved #{@user.full_name}, an email has been sent to #{@user.email}"
      AccountMailer.account_approval(@user).deliver
    else
      flash[:alert] = "Oops something went wrong!"
    end
    redirect_to user_path(@user)
  end

  def roles
    authenticate_superuser! # roles are shown on a user's show page, no reason for civilians to be here
    @current_semester = MemberSemester.current
    @roles = @user.roles.order(:resource_id, :role_type)
  end

  def alter_roles
    authenticate_superuser!
    if params[:delete]
      r = Role.find_by_id(params[:role])
      @user.delete_role(r)
      flash[:notice] = @user.full_name + " has lost the title " + r.nice_position + " in " + r.nice_semester
    else
      semester = MemberSemester.find_by_season_and_year(params[:season], params[:year])
      @user.add_position_for_semester_and_role_type(params[:position], semester, params[:role])
      role = Role.find_by_name_and_resource_id_and_role_type(params[:position], semester.id, params[:role])
      flash[:notice] = @user.full_name + " has gained the title " + role.nice_position + " in " + role.nice_semester
    end
    @user.update_attribute :should_reset_session, true
    redirect_to edit_roles_user_path(@user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.require(:user).permit(:email, :password, :private, :picture, :password_confirmation, :phone_number, :sms_alerts, :date_of_birth, :mobile_carrier_id)
    end
end
