class RegistrationsController < Devise::RegistrationsController
  def create
    unless verify_recaptcha()
      flash.delete(:recaptcha_error)
      redirect_to new_user_registration_path, alert: "oops recaptcha failed" and return
    end
    super
  end
end