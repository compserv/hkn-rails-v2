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

  def authorize(group)
    unless authenticate_user! and (current_user.is_current_officer?(group_or_groups) || current_user.is_current_officer?(:compserv))
      redirect_to root_path, alert: "You do not have permission(#{group_or_groups}) to access that"
    end 
  end
end
