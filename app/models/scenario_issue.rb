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
# == Table: scenario_issues
#
#  coordinates              :text
#  coordinates_nature       :string
#  created_at               :datetime
#  description              :text
#  destruction_percentage   :decimal(19, 4)
#  id                       :integer          not null, primary key
#  impacted_indicator_name  :string
#  impacted_indicator_value :string
#  maximal_age              :integer
#  minimal_age              :integer
#  name                     :string           not null
#  nature                   :string           not null
#  scenario_id              :integer          not null
#  trigger_turn             :integer
#  updated_at               :datetime
#  variety                  :string
#

class ScenarioIssue < ActiveRecord::Base
  extend Enumerize
  belongs_to :scenario, class_name: 'Scenario'
  enumerize :nature, in: [:climate_event, :wild_animal_ravage]
  enumerize :coordinates_nature, in: [:geojson]
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :maximal_age, :minimal_age, :trigger_turn, allow_nil: true, only_integer: true
  validates_numericality_of :destruction_percentage, allow_nil: true
  validates_presence_of :name, :nature, :scenario
  # ]VALIDATORS]
end
