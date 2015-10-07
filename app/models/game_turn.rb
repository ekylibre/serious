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
#  created_at    :datetime
#  duration      :integer          not null
#  expenses_paid :boolean          default(FALSE), not null
#  game_id       :integer          not null
#  id            :integer          not null, primary key
#  number        :integer          not null
#  started_at    :datetime
#  stopped_at    :datetime
#  updated_at    :datetime
#
class GameTurn < ActiveRecord::Base
  belongs_to :game
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :started_at, :stopped_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :duration, :number, allow_nil: true, only_integer: true
  validates_inclusion_of :expenses_paid, in: [true, false]
  validates_presence_of :duration, :game, :number
  # ]VALIDATORS]
  validates_numericality_of :number, greater_than: 0

  scope :at, ->(at) { where('started_at <= ? AND ? < stopped_at', at, at) }

  before_validation do
    if number
      if number == 1
        self.started_at = game.launched_at || game.planned_at
      else
        self.started_at ||= previous.stopped_at
      end
      self.stopped_at = self.started_at + duration * 60
    end
  end

  before_save do
    if (other = previous) && other.stopped_at > self.started_at
      puts 'previous'
      delta = self.started_at - other.stopped_at
      other.started_at += delta
      other.stopped_at += delta
      other.save!
    end
    if (other = following) && other.started_at < stopped_at
      puts 'following'
      delta = stopped_at - other.started_at
      other.started_at += delta
      other.stopped_at += delta
      other.save!
    end
  end

  def inside_started_at
    (game.started_on + (number - 1).months).beginning_of_month
  end

  def inside_stopped_at
    (game.started_on + (number - 1).months).end_of_month
  end

  def frozen_at
    inside_stopped_at.beginning_of_day + 14.hours
  end

  def finished_on
    frozen_at.to_date
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

  def previous
    siblings.find_by(number: number - 1)
  end

  def following
    siblings.find_by(number: number + 1)
  end

  def siblings
    game.turns
  end

  def others
    siblings.where('id != ?', id || 0)
  end

  def current?
    self.started_at <= Time.now && Time.now < stopped_at
  end

  def past?
    stopped_at < Time.now
  end

  def future?
    self.started_at >= Time.now
  end
end
