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
# == Table: game_turns
#
#  created_at :datetime
#  duration   :integer          not null
#  game_id    :integer          not null
#  id         :integer          not null, primary key
#  number     :integer          not null
#  started_at :datetime
#  stopped_at :datetime
#  updated_at :datetime
#
class GameTurn < ActiveRecord::Base
  belongs_to :game
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :started_at, :stopped_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :duration, :number, allow_nil: true, only_integer: true
  validates_presence_of :duration, :game, :number
  #]VALIDATORS]
  validates_numericality_of :number, greater_than: 0

  scope :at, lambda { |at| where('started_at <= ? AND ? < stopped_at', at, at) }

  before_update do
    self.stopped_at = self.started_at + self.game.turn_duration.minutes
  end

  before_validation do
    if self.started_at && self.stopped_at
      self.duration = (self.stopped_at - self.started_at).to_i
    end
  end

  # validate do
  #   if self.others.at(self.started_at).any?
  #     errors.add(:started_at, :invalid)
  #   end
  #   if self.others.at(self.stopped_at).any?
  #     errors.add(:stopped_at, :invalid)
  #   end
  # end

  def others
    self.game.turns.where('id != ?', self.id || 0)
  end

end
