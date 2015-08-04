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
#  shift      :integer          default(0), not null
#  started_at :datetime
#  stopped_at :datetime
#  updated_at :datetime
#
class GameTurn < ActiveRecord::Base
  belongs_to :game
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :started_at, :stopped_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :duration, :number, :shift, allow_nil: true, only_integer: true
  validates_presence_of :duration, :game, :number, :shift
  # ]VALIDATORS]
  validates_numericality_of :number, greater_than: 0

  scope :at, ->(at) { where('started_at <= ? AND ? < stopped_at', at, at) }

  before_update do
    self.stopped_at = started_at + game.turn_duration.minutes
  end

  before_validation do
    self.duration = (stopped_at - started_at).to_i if started_at && stopped_at
  end

  def finished_on
    (Date.civil(2015, 9, 30) >> (number - 1)).end_of_month
  end

  def name
    finished_on.l(format: '%m/%Y')
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
    game.turns.where('id != ?', id || 0)
  end
end
