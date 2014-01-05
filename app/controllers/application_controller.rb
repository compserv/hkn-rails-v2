class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)}
  end

  helper_method :authorize, :candidate_authorize

  def method_missing(name, *args)
    case name.to_s
      when /^authenticate_([_a-zA-Z]\w*)!$/
        group = $1
        self.send :authenticate!, group
      when /^authenticate_([_a-zA-Z]\w*)$/
        group = $1
        self.send :authorize, group
      else
        super
    end
  end

  def authorize(group)
    current_user and (current_user.is_current_officer?(group) || current_user.is_current_officer?(:compserv))
  end

  def candidate_authorize
    current_user and current_user.has_ever_had_role?(:candidate)
  end

  def authenticate!(group)
    unless authenticate_user! and (current_user.is_current_officer?(group) || current_user.is_current_officer?(:compserv))
      redirect_to root_path, alert: "You do not have permission(#{group}) to access that"
    end
  end
end
