class BlockRsvp < ActiveRecord::Base
  belongs_to :block
  belongs_to :rsvp
end
