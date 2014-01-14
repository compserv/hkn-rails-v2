class IndrelMailer < ActionMailer::Base

  def infosession_registration(infosession_request)
    @infosession_request = infosession_request
    mail to: "indrel@hkn.eecs.berkeley.edu",
         from: "infosessions-registration@hkn.eecs.berkeley.edu",
         subject: "Infosession registration from #{@infosession_request.company_name}"
  end

  def resume_book_bought(url)
    @url = url
    mail to: "#{url.email}",
         from: "indrel@hkn.eecs.berkeley.edu",
         subject: "Resume Book Information"
  end

  def resume_book_bought_to_indrel(url)
    @url = url
    mail to: "indrel@hkn.eecs.berkeley.edu",
         from: "indrel@hkn.eecs.berkeley.edu",
         subject: "Resume Book Bought"
  end

end
