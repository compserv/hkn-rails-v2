require 'will_paginate/array'

class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /users
  def index
    @users = User
  end

  # GET /users/new
  def new
    @user = user.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
  end

  # PATCH/PUT /users/1
  def update
  end

  # DELETE /users/1
  def destroy
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
