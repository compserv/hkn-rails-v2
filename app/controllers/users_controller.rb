require 'will_paginate/array'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :approve]
  before_filter :authenticate_user!

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
    unless @user == current_user || authorize(:superuser)
      redirect_to edit_user_path(current_user) and return
    end

    @mobile_carriers# = MobileCarrier.all
  end

  # POST /users
  def create
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
      redirect_to path, :notice => "You must enter in your current password to make any changes." and return
    end

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    # DO IT
    if @user.update_attributes(user_params)
      redirect_to path, :notice => 'Settings successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    unless @user == current_user || authorize(:superuser)
      redirect_to edit_user_path(current_user) and return
    end
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def list
    opts = { :page     => params[:page],
             :per_page => params[:per_page] || 20,
           }
    if params[:approved] == "false"
      @users = User.where(approved: false).paginate opts
    else
      @users = MemberSemester.current.send("#{params[:category]}".to_sym).paginate opts
    end
  end

  def approve
    if @user.update(approved: true)
      flash[:notice] = "Successfully approved #{@user.full_name}, an email has been sent to #{@user.email}"
      AccountMailer.account_approval(@user).deliver
    else
      flash[:alert] = "Oops something went wrong!"
    end
    redirect_to user_path(@user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.require(:user).permit(:email, :password, :private, :picture, :password_confirmation, :phone_number, :sms_alerts, :date_of_birth)
    end
end
