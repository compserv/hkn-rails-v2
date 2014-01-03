class UserMailer < ActionMailer::Base
  def send_sms(user, msg)
    mail(:from => "sms-alerts@hkn.eecs.berkeley.edu",
         :to => user.sms_email_address,
         :subject => "") do |format|
      format.text { render :text => msg}
    end
  end
end
