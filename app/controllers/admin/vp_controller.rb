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

  private

    def cands
      Role.semester_filter(MemberSemester.current).candidates.all_users.sort_by {|c| c.last_name.downcase || "zzz"  }
    end

end
