# == Schema Information
#
# Table name: alumnis
#
#  id            :integer          not null, primary key
#  grad_semester :string(255)
#  grad_school   :string(255)
#  job_title     :string(255)
#  company       :string(255)
#  salary        :integer
#  user_id       :integer
#  perm_email    :string(255)
#  location      :string(255)
#  suggestions   :text
#  mailing_list  :boolean
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Alumni do
  pending "add some examples to (or delete) #{__FILE__}"
end
