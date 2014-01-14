# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :text
#  comments   :text
#  created_at :datetime
#  updated_at :datetime
#  website    :string(255)
#

class Company < ActiveRecord::Base

  def urls
    ResumeBookUrl.where(company: name).includes(:resume_book)
  end

  def urls_count
    ResumeBookUrl.where(company: name).count
  end
end
