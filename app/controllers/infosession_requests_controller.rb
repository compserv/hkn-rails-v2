class InfosessionRequestsController < ApplicationController

  def about
  end

  def new
    @infosession_request = InfosessionRequest.new
  end

  def create
    @infosession_request = InfosessionRequest.new(infosession_request_params)
    if @infosession_request.save
      IndrelMailer.infosession_request(@infosession_request).deliver
    else
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
