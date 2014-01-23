# == Schema Information
#
# Table name: slideshows
#
#  id                     :integer          not null, primary key
#  member_semester_id     :integer
#  created_at             :datetime
#  updated_at             :datetime
#  slideshow_file_name    :string(255)
#  slideshow_content_type :string(255)
#  slideshow_file_size    :integer
#  slideshow_updated_at   :datetime
#

require 'spec_helper'

describe Slideshow do
  pending "add some examples to (or delete) #{__FILE__}"
end
