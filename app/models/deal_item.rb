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
# == Table: deal_items
#
#  amount             :decimal(19, 4)
#  created_at         :datetime
#  deal_id            :integer          not null
#  id                 :integer          not null, primary key
#  pretax_amount      :decimal(19, 4)
#  quantity           :decimal(19, 4)
#  tax                :string
#  unit_amount        :decimal(19, 4)
#  unit_pretax_amount :decimal(19, 4)
#  updated_at         :datetime
#  variant            :string
#
class DealItem < ActiveRecord::Base
  belongs_to :deal
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount, :pretax_amount, :quantity, :unit_amount, :unit_pretax_amount, allow_nil: true
  validates_presence_of :deal
  #]VALIDATORS]
  before_validation do
    self.quantity ||= 0
  end
end
