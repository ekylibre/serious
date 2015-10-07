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
# == Table: participant_ratings
#
#  created_at     :datetime
#  game_id        :integer          not null
#  id             :integer          not null, primary key
#  participant_id :integer          not null
#  rated_at       :datetime         not null
#  report         :json
#  updated_at     :datetime
#
class ParticipantRating < ActiveRecord::Base
  belongs_to :game
  belongs_to :participant
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :rated_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_presence_of :game, :participant, :rated_at
  # ]VALIDATORS]

  before_validation do
    self.game ||= participant.game if participant
  end

  def value
    report['passed'].to_i
  end

  def percentage_value
    report['passed'].to_i / (report['passed'].to_i + report['failed'].to_i)
  end
end
