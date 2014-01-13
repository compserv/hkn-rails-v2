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
#

require 'spec_helper'

describe ResumeBookUrl do
  pending "add some examples to (or delete) #{__FILE__}"
end
