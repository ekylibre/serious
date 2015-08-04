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
# == Table: scenario_broadcasts
#
#  content      :text
#  created_at   :datetime
#  id           :integer          not null, primary key
#  name         :string           not null
#  release_turn :integer          not null
#  scenario_id  :integer          not null
#  updated_at   :datetime
#
class ScenarioBroadcast < ActiveRecord::Base
  belongs_to :scenario
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :release_turn, allow_nil: true, only_integer: true
  validates_presence_of :name, :release_turn, :scenario
  # ]VALIDATORS]
end
