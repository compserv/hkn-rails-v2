class InfosessionRequestsController < ApplicationController

  def about
  end

  def new
    @infosession_request = InfosessionRequest.new
  end

  def create
    @infosession_request = InfosessionRequest.new(infosession_request_params)
    if verify_recaptcha(model: @infosession_request, message: "Oops, recaptcha failed!") && @infosession_request.save
      IndrelMailer.infosession_registration(@infosession_request).deliver
      redirect_to infosessions_path, notice: "Infosession Request for #{@infosession_request.company_name} has been submitted."
    else
      flash.delete(:recaptcha_error)
      render :new
    end
  end

  private

    def infosession_request_params
      params.require(:infosession_request).permit(:company_name, :address1, :address2, :city,
                                                  :state, :zip_code, :name, :title, :phone, :email,
                                                  :alt_name, :alt_title, :alt_phone, :alt_email,
                                                  :pref_date, :pref_food, :pref_ad, :comments)
    end
end
