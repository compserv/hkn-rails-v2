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

require 'spec_helper'

describe ResumeBookUrl do
  pending "add some examples to (or delete) #{__FILE__}"
end
