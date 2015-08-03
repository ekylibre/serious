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
#  description            :string           not null
#  destruction_percentage :decimal(19, 4)
#  id                     :integer          not null, primary key
#  impact_indicator_name  :string
#  impact_indicator_value :decimal(19, 4)
#  maximal_age            :integer
#  minimal_age            :integer
#  name                   :string           not null
#  nature                 :string           not null
#  scenario_id            :integer          not null
#  shape                  :geometry({:srid=>0, :type=>"multi_polygon"})
#  trigger_turn           :integer          not null
#  turn                   :integer          not null
#  variety                :string           not null
#
require 'test_helper'

class ScenarioIssueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
