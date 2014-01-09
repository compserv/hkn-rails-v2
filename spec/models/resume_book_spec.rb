# == Schema Information
#
# Table name: resume_books
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  remarks          :string(255)
#  details          :text
#  cutoff_date      :date
#  created_at       :datetime
#  updated_at       :datetime
#  pdf_file_name    :string(255)
#  pdf_content_type :string(255)
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#

require 'spec_helper'

describe ResumeBook do
  pending "add some examples to (or delete) #{__FILE__}"
end
