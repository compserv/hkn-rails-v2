class Exam < ActiveRecord::Base
  has_attached_file :file, :styles => { :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
end
