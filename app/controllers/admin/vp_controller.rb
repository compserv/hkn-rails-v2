class Admin::VpController < ApplicationController
  before_filter :authenticate_vp!

  def index
  end

  def applications
  end

  def byperson
    @candidates = cands

    respond_to do |format|
      format.html
      format.csv  {render :layout => false}
    end
  end

  def bycommittee
    @mapping = cands.group_by {|c| c.committee_preferences and c.committee_preferences.split.first}

    respond_to do |format|
      format.html
      format.csv   {render :layout => false}
    end
  end

  def byperson_without_application
    @candidates = cands.reject {|c| c.committee_preferences}

    respond_to do |format|
      format.html
      format.csv  {render :layout => false}
    end
  end

  def super_page
    @semester = params[:semester] ? MemberSemester.find_by_id(params[:semester]) : MemberSemester.current
    @candidates = cands(@semester)
    @req = Hash.new { |h,k| 0 }
    @req["Mandatory for Candidates"] = 3
    @req["Fun"] = 3
    @req["Big Fun"] = 1
    @req["Service"] = 2
  end

  def promote_candidate
    return unless params[:id]
    User.find_by_id(params[:id]).add_position_for_semester_and_role_type(:member, MemberSemester.current, :member)
    redirect_to admin_vp_super_page_path(params[:semester])
  end

  private

    def cands(semester = MemberSemester.current)
      Role.semester_filter(semester).candidates.all_users.sort_by {|c| c.last_name.downcase || "zzz"  }
    end

end
