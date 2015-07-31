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
# == Table: contracts
#
#  contractor_id    :integer          not null
#  created_at       :datetime
#  delivery_turn    :integer          not null
#  id               :integer          not null, primary key
#  nature_id        :integer          not null
#  quantity         :decimal(19, 4)   not null
#  state            :string
#  subcontractor_id :integer
#  updated_at       :datetime
#
require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
