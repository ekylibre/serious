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
#  amount       :decimal(19, 4)   not null
#  created_at   :datetime
#  id           :integer          not null, primary key
#  insurance_id :integer          not null
#  paid_on      :date             not null
#  updated_at   :datetime
#
class InsuranceIndemnification < ActiveRecord::Base
  belongs_to :insurance
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_date :paid_on, allow_blank: true, on_or_after: Date.civil(1, 1, 1)
  validates_numericality_of :amount, allow_nil: true
  validates_presence_of :amount, :insurance, :paid_on
  # ]VALIDATORS]
end
