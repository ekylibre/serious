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
# == Table: scenarios
#
#  code                  :string           not null
#  created_at            :datetime
#  currency              :string           not null
#  description           :text
#  historic_content_type :string
#  historic_file_name    :string
#  historic_file_size    :integer
#  historic_updated_at   :datetime
#  id                    :integer          not null, primary key
#  monthly_expenses      :json
#  name                  :string           not null
#  started_on            :date             not null
#  turn_nature           :string
#  turns_count           :string           not null
#  updated_at            :datetime
#
require 'test_helper'

class ScenarioTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
