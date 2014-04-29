class RSVPMailer < ActionMailer::Base
  def rsvp_email(user, event)
    @user = user
    @event = event 
    mail(
      :from => "no-reply@hkn.eecs.berkeley.edu",
      :to => user.email,
      :subject => "[HKN] RSVP Notification"
    )
  end
end
