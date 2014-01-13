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
    @paypal = paypal_encrypted(resume_books_paypal_sucess_url(:secret => 'hihihihi'))
  end

  def resume_books_order_paypal_success
    redirect_to root_path, alert: "don't hack" and return unless params[:secret] == 'hihihihi'
    check_transaction_params = {
      :tx => params[:tx],
      :at => 'NKNku30eq5MOjRFmadxjNlk-f-nCMbKulQ0tidvoUIjCNvBQDCX1B8CKgDe',
      :cmd => '_notify-synch'
    }
    x = Net::HTTP.post_form(URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr'), check_transaction_params)
    response = URI.decode(x.body.gsub('+', ' ')).split("\n")
    if response[0] != "SUCCESS"
      x = Net::HTTP.post_form(URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr'), check_transaction_params)
      response = URI.decode(x.body).split("\n")
      if response[0] != "SUCCESS"
        render json: "SOMETHING WENT WRONG?"
      end
    end
    p = {}
    response.each do |element|
      a = element.split("=")
      if a.length == 2
        p[a[0]] = a[1]
      end
    end

    if p["payment_status"] == "Completed" && p["receiver_email"] == "kcasey9111@yahoo.com" && p["item_number"] == "9001" && p["mc_gross"] == "250.00"
      
    else
      
    end

    
  end

  def paypal_encrypted(return_url)
    values = {
      :cmd => '_xclick',
      :business => 'kcasey9111@yahoo.com',
      :lc => 'US',
      :item_name => 'Resume Book',
      :amount => '250.00',
      :currency_code => 'USD',
      :button_subtype => 'services',
      :no_note => '1',
      :no_shipping => '1',
      :rm => '2',
      :item_number => '9001',
      :return => return_url,
      :bn => 'PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted',
      :cert_id => "XASDKBEFML5YQ"
    }
    encrypt_for_paypal(values)
  end

  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert.pem")
  APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
  APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

end
