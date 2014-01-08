class Admin::BridgeController < ApplicationController
  before_filter :authenticate_bridge!

  def index
  end

  def officer_photo_index
    @officers = MemberSemester.current.officers
  end

  def officer_photo_upload
    officer = User.find_by_id(params[:user][:id])
    officer.picture = params[:file_info]
    if officer.save
      flash[:notice] = "Successfully uploaded "
    else
      flash[:notice] = "Failed to upload "
    end
    flash[:notice] += "photo for #{officer.full_name}"
    redirect_to admin_bridge_officer_index_path
  end
end
