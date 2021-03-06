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
# == Table: scenario_curves
#
#  amount_round           :integer
#  amplitude_factor       :decimal(19, 4)   default(1), not null
#  code                   :string           not null
#  created_at             :datetime
#  description            :text
#  id                     :integer          not null, primary key
#  initial_amount         :decimal(19, 4)
#  interpolation_method   :string
#  name                   :string           not null
#  nature                 :string           not null
#  negative_alea_amount   :decimal(19, 4)   default(0), not null
#  offset_amount          :decimal(19, 4)   default(0), not null
#  positive_alea_amount   :decimal(19, 4)   default(0), not null
#  reference_id           :integer
#  scenario_id            :integer          not null
#  unit_name              :string
#  updated_at             :datetime
#  variant_indicator_name :string
#  variant_indicator_unit :string
#
require 'test_helper'

class ScenarioCurveTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
