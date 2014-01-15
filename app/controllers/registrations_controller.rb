class RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)
    unless verify_recaptcha()
      flash.delete(:recaptcha_error)
      flash.now[:alert] = "oops recaptcha failed"
      render :new and return
    end

    super
  end

end
