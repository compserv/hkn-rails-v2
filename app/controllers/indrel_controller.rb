class IndrelController < ApplicationController

  protect_from_forgery :except => [:resume_books_order_paypal_success, :resume_books_order_paypal_email]

  def why_hkn
    @indrel_officers = Role.current_officers_from_committee 'indrel'
    @officer_count = Role.current_officers.count
  end

  def contact_us
    @indrel_officers = Role.current_officers_from_committee 'indrel'
  end

  def career_fair
  end

  def resume_books
    book = ResumeBook.last # grabs last by id, same as most current

    @year_counts = book.details

    @sum = 0
    @year_counts.each do |year, count|
      @sum += count.to_i
    end
  end

  def resume_books_order
    @paypal = paypal_encrypted(resume_books_paypal_success_url)
  end

  def resume_books_transaction_id
    redirect_to resume_books_paypal_success_path(:tx => params[:transaction_id])
  end

  def resume_books_order_paypal_success
    check_transaction_params = {
      :tx => params[:tx],
      :at => ENV["paypal_identity_token"],
      :cmd => '_notify-synch'
    }
    x = Net::HTTP.post_form(URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr'), check_transaction_params)
    response = URI.decode(x.body.gsub('+', ' ')).split("\n")
    if response[0] != "SUCCESS" # attempt one more time, in case paypal just missed it or something
      x = Net::HTTP.post_form(URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr'), check_transaction_params)
      response = URI.decode(x.body).split("\n")
      if response[0] != "SUCCESS"
        render json: "Oops, the transaction id '#{params[:tx]}' didn't appear to be a valid transaction according to paypal.  Please try again if this is a mistake" and return
      end
    end
    p = {} # parse information about the transaction from paypal into a hash that's easier to use
    response.each do |element|
      a = element.split("=")
      if a.length == 2
        p[a[0]] = a[1]
      end
    end


    if p["payment_status"] == "Completed" && p["receiver_email"] == ENV["paypal_email"] && p["item_number"] == ENV["paypal_item_number"] && p["mc_gross"] == "250.00" && p["item_name"] == "Resume Book" && p["quantity"] == "1"
      if ResumeBookUrl.find_by_transaction_id(p["txn_id"]).nil?
        # transaction was successful. generate a resume_book_url
        p["first_name"] ||= ""
        p["last_name"] ||= ""
        name = p["first_name"] + " " + p["last_name"]
        url = ResumeBookUrl.create(password: SecureRandom.urlsafe_base64(100), resume_book_id: ResumeBook.last.id, expiration_date: 1.month.from_now, download_count: 0, email: p["payer_email"], name: name, transaction_id: p["txn_id"], company: p["payer_business_name"])
        flash[:notice] = "Thank you for your purchase. Your transaction has been completed, and a receipt for your purchase has been emailed to you, additionally information has been sent to your paypal email from hkn. You may log into your account at www.sandbox.paypal.com/us to view details of this transaction."
        @link = resume_book_download_pdf_url(url.resume_book_id, string: url.password)
        IndrelMailer.resume_book_bought(url).deliver
        IndrelMailer.resume_book_bought_to_indrel(url).deliver
        comm = "bought resume book on #{url.created_at.strftime("%B %d, %Y at %I:%M %p")}"
        debugger
        if !url.company.nil?
          company = Company.where(name: url.company).first_or_create
          company.update_attribute :comments, company.comments.to_s + " " + comm
          contact = Contact.where(name: url.name, email: url.email, company_id: company.id).first_or_create
          contact.update_attribute :comments, contact.comments.to_s + " " + comm
        else
          contact = Contact.where(name: url.name, email: url.email).first_or_create
          contact.update_attribute :comments, contact.comments.to_s + " " + comm
        end
      else
        flash[:notice] = "This transaction has already generated a download link, remember to check the email with your paypal account or email indrel@hkn.eecs.berkeley.edu with your paypal transaction id"
        @link = root_path
      end
    else
      flash[:alert] = "Something went wrong! It appears like that transaction doesn't correspond to buying a resume book with us.  You're link will not work. Please email indrel@hkn.eecs.berkeley.edu if this is a mistake"
      @link = root_path
    end
  end

  def paypal_encrypted(return_url)
    values = {
      :cmd => '_xclick',
      :business => ENV["paypal_email"],
      :lc => 'US',
      :item_name => 'Resume Book',
      :amount => '250.00',
      :currency_code => 'USD',
      :button_subtype => 'services',
      :no_note => '1',
      :no_shipping => '1',
      :rm => '2',
      :item_number => ENV["paypal_item_number"],
      :return => return_url,
      :bn => 'PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted',
      :cert_id => "XASDKBEFML5YQ"
    }
    encrypt_for_paypal(values)
  end

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(ENV["APP_CERT_PEM"]), OpenSSL::PKey::RSA.new(ENV["APP_KEY_PEM"], ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(ENV["PAYPAL_CERT_PEM"])], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

end
