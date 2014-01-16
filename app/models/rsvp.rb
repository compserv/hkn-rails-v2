# == Schema Information
#
# Table name: rsvps
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  event_id               :integer
#  confirmed              :string(255)
#  confirmed_by           :integer
#  confirmed_at           :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  comment                :string(255)
#  transportation_ability :integer
#

class Rsvp < ActiveRecord::Base
  before_validation :set_default_transportation

  TRANSPORT_ENUM = [
    [ 'I need a ride', -1 ],
    [ "Don't worry about me", 0 ],
    [ 'I have a small sedan (4 seats)', 3 ],
    [ 'I have a sedan (5 seats)', 4 ],
    [ 'I have a minivan (7 seats)', 6 ],
  ]

  Confirmed   = 't'
  Unconfirmed = 'f'
  Rejected    = 'r'

  belongs_to :user
  belongs_to :event

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :comment, length: { maximum: 300 }
  validates_inclusion_of :confirmed, :in => [Confirmed, Unconfirmed, Rejected, nil]

  def need_transportation
    event and event.need_transportation?
  end

  private
    def set_default_transportation
      if self.need_transportation
        self.transportation_ability ||= TRANSPORT_ENUM.first.last
      end
    end
end
