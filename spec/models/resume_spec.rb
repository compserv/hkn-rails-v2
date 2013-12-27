# == Schema Information
#
# Table name: resumes
#
#  id                  :integer          not null, primary key
#  overall_gpa         :decimal(, )
#  major_gpa           :decimal(, )
#  resume_text         :text
#  graduation_year     :integer
#  graduation_semester :string(255)
#  user_id             :integer
#  included            :boolean
#  created_at          :datetime
#  updated_at          :datetime
#  file_file_name      :string(255)
#  file_content_type   :string(255)
#  file_file_size      :integer
#  file_updated_at     :datetime
#

require 'spec_helper'

describe Resume do
  pending "add some examples to (or delete) #{__FILE__}"
end
