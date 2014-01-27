# == Schema Information
#
# Table name: staff_members
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  release_surveys :boolean
#  created_at      :datetime
#  updated_at      :datetime
#  picture         :string(255)
#  title           :string(255)
#  interests       :text
#  home_page       :string(255)
#  office          :string(255)
#  phone_number    :string(255)
#  email           :string(255)
#

class StaffMember < ActiveRecord::Base
  has_many :course_staff_members
  has_many :survey_question_responses, through: :course_staff_members
  has_many :course_offerings, through: :course_staff_members
  has_many :courses, through: :course_offerings
  has_many :survey_question_responses, through: :course_staff_members

  validates :first_name, presence: true
  validates :last_name, presence: true

  def find_surveys_by_semester(course_semester)
    return course_surveys.where("course_surveys.course_semester_id = #{course_semester.id}")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_r
    [last_name, first_name].join ', '
  end

  # Eat another instructor
  # This destroys the other instructor, moving all of his/her
  # associations to this one.
  # @return [boolean] true if operation was successful
  #
  # THIS SHOULD BE WRAPPED IN A TRANSACTION
  # ITS DESTRUCTIVE
  #
  def eat(victims)
    b = true
    victims = [*victims]
    raise "Nil victim" unless victims.all?

    things = victims.collect(&:course_staff_members).flatten
    puts "iships = #{things.inspect}\n\n"

    [*victims].each do |victim|
        puts "about to eat #{victim.inspect}\n"
        raise "Failed to destroy" unless victim.destroy
    end

    raise "Can't save self" if self.new_record? && !self.save

    things.each do |thing|
      puts "  updating #{thing.inspect}"
      raise "Failed update" unless thing.update_attribute(:staff_member_id, self.id)
      thing.reload
      raise "Failed check" unless thing.staff_member_id == self.id
    end

    puts "eat #{victims.inspect} returning okay"
    true
  end
end
