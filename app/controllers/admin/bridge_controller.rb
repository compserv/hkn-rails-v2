class Admin::BridgeController < ApplicationController
  def index
  end

  def officer_photo_index
    @officers = MemberSemester.current.officers
  end

  def officer_photo_upload
    officer = User.find_by_id(params[:user][:id])
    officer.picture = params[:file_info]
    if officer.save
      flash[:notice] = "Successfully uploaded photo for #{officer.full_name}"
    else
      flash[:alert] = "Failed to upload photo for #{officer.full_name}"
    end
    redirect_to admin_bridge_officer_index_path
  end
end
