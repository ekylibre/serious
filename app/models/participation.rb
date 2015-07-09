# = Informations
#
# == License
#
# Serious - Serious Game based on Ekylibre
# Copyright (C) 2015-2015 Ekylibre SAS
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# == Table: participations
#
#  created_at     :datetime
#  game_id        :integer          not null
#  id             :integer          not null, primary key
#  nature         :string           not null
#  participant_id :integer
#  updated_at     :datetime
#  user_id        :integer          not null
#

# A participation permits to define which role a user can have in a game.
# An user can cumulate partipations for the same game.
class Participation < ActiveRecord::Base
  extend Enumerize
  enumerize :nature, in: [:organizer, :player], default: :player, predicates: true
  belongs_to :game
  belongs_to :participant
  belongs_to :user
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_presence_of :game, :nature, :user
  #]VALIDATORS]
  validates_presence_of :participant, if: :player?

  before_validation do
    if self.organizer?
      self.participant = nil
    end
    if self.participant
      self.game ||= self.participant.game
    end
  end

  validate do
    if self.game and self.participant
      errors.add(:game, :invalid) if self.game != self.participant.game
    end
  end


  # Define for current participation if given participant can be seen
  def can_see?(participant)
    self.organizer? or
      (self.participant.is_a?(Actor) and participant.is_a?(Farm)) or
      (self.participant.is_a?(Farm) and participant.is_a?(Actor))
  end

end
