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
# == Table: insurance_indemnifications
#
#  id              :integer          not null, primary key
#  insurance_id_id :integer          not null
#  montant         :decimal(, )      not null
#  paid_on         :date             not null
#
require 'test_helper'

class InsuranceIndemnificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
