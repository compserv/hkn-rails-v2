class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def method_missing(name, *args)
    case name.to_s
      when /^authenticate_([_a-zA-Z]\w*)$/
        group = $1
        self.send :authorize, group
      else
        super
    end
  end

  def authorize(group_or_groups=nil)
    # group_or_groups must be either a single Group name or an array of Group names
    # If user is in any of the groups, then s/he has access
    # If group_or_groups is not specified (called authorize with no arguments), then should return true if the person is logged in, false otherwise.
    redirect_to root_path, alert: "You do not have permission(#{group_or_groups}) to access that" unless (authenticate_user! and current_user.has_ever_had_role?(group_or_groups))
  end
end
