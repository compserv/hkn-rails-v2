# == Schema Information
#
# Table name: indrel_events
#
#  id                   :integer          not null, primary key
#  time                 :datetime
#  location_id          :integer
#  indrel_event_type_id :integer
#  food                 :text
#  prizes               :text
#  turnout              :integer
#  company_id           :integer
#  contact_id           :integer
#  officer              :string(255)
#  feedback             :text
#  comments             :text
#  created_at           :datetime
#  updated_at           :datetime
#

class IndrelEvent < ActiveRecord::Base
  belongs_to :location
  belongs_to :indrel_event_type
  belongs_to :company
  belongs_to :contact

  def location_name
    location.name if location
  end

  def indrel_event_type_name
    indrel_event_type.name if indrel_event_type
  end

  def company_name
    company.name if company
  end

  def contact_name
    contact.name if contact
  end
end
