class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)}
  end

  helper_method :authorize, :candidate_authorize, :comm_authorize, :active_member_authorize

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
    return unless current_user
    if !user_session[group].nil?
      user_session[group]
    elsif current_user.has_ever_had_position?(group) || current_user.is_current_officer?(:compserv)
      user_session[group] = true # assigns and returns true
    else
      user_session[group] = false # assigns and returns false
    end
  end

  def candidate_authorize
    return unless current_user
    user_session[:candidate].nil? ? (user_session[:candidate] = current_user.has_ever_had_role?(:candidate)) : user_session[:candidate]
  end

  def comm_authorize
    return unless current_user
    user_session[:comm].nil? ? user_session[:comm] = current_user.has_ever_had_role?(:committee_member) || current_user.has_ever_had_role?(:officer) : user_session[:comm]
  end

  def comm_authorize!
    if !comm_authorize
      redirect_to new_user_session_path, :notice => "Please log in to access this page."
    end
  end

  def active_member_authorize
    return unless current_user
    user_session[:current_comm].nil? ? user_session[:current_comm] = current_user.is_active_member? : user_session[:current_comm]
  end

  def authenticate!(group)
    unless authorize(group)
      redirect_to root_path, alert: "You do not have permission(#{group}) to access that"
    end
  end
end
