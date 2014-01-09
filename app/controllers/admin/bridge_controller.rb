class Admin::BridgeController < ApplicationController
  before_filter :authenticate_bridge!

  def index
  end

  def officer_photo_index
    @officers = MemberSemester.current.officers
  end

  def officer_photo_upload
    redirect_to admin_bridge_officer_index_path, alert: "Params missing" and return unless params[:user].has_key?(:id) && params.has_key?(:file_info)
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
