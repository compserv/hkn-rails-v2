# == Schema Information
#
# Table name: resume_book_urls
#
#  id              :integer          not null, primary key
#  resume_book_id  :integer
#  expiration_date :datetime
#  feedback        :text
#  password        :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  download_count  :integer
#  company         :string(255)
#  name            :string(255)
#  email           :string(255)
#  transaction_id  :string(255)
#

class ResumeBookUrl < ActiveRecord::Base
  belongs_to :resume_book
  validates_presence_of :resume_book_id, :password, :download_count, :expiration_date

  def expired?
    Time.now > self.expiration_date
  end

  def make_company_and_contact
    comment = "bought resume book on #{self.created_at.strftime("%B %d, %Y at %I:%M %p")}"
    if !self.company.nil?
      company = Company.where(name: self.company).first_or_create
      company.update_attribute :comments, company.comments.to_s + " " + comment
      contact = Contact.where(name: self.name, email: self.email, company_id: company.id).first_or_create
      contact.update_attribute :comments, contact.comments.to_s + " " + comment
    else
      contact = Contact.where(name: self.name, email: self.email).first_or_create
      contact.update_attribute :comments, contact.comments.to_s + " " + comment
    end
  end
end
