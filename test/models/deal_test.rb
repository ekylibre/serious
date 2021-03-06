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
# == Table: deals
#
#  amount        :decimal(19, 4)   default(0), not null
#  created_at    :datetime
#  customer_id   :integer          not null
#  game_id       :integer          not null
#  id            :integer          not null, primary key
#  invoiced_at   :datetime
#  pretax_amount :decimal(19, 4)   default(0), not null
#  state         :string           not null
#  supplier_id   :integer          not null
#  updated_at    :datetime
#
require 'test_helper'

class DealTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
