class AccountMailer < ActionMailer::Base
  def account_approval(user)
    @user = user
    mail(
      :from => "no-reply@hkn.eecs.berkeley.edu",
      :to => user.email,
      :subject => "[HKN] Account approved"
    )
  end
end
