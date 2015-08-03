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
# == Table: insurances
#
#  amount                 :decimal(, )
#  excess_amount          :decimal(, )
#  id                     :integer          not null, primary key
#  insured_id             :integer          not null
#  insurer_id             :integer          not null
#  nature                 :string           not null
#  pretax_amount          :decimal(, )      not null
#  quantity_unit          :string
#  quantity_value         :decimal(, )
#  tax                    :decimal(, )
#  unit_pretax_amount     :decimal(, )      not null
#  unit_refundable_amount :decimal(, )      not null
#
class Insurance < ActiveRecord::Base
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount, :excess_amount, :pretax_amount, :quantity_value, :tax, :unit_pretax_amount, :unit_refundable_amount, allow_nil: true
  validates_presence_of :insured, :insurer, :nature, :pretax_amount, :unit_pretax_amount, :unit_refundable_amount
  #]VALIDATORS]
  belongs_to :insured, class_name: 'Participant'
  belongs_to :insurer, class_name: 'Participant'

  before_validation do
    self.pretax_amount = self.quantity_unit * self.unit_pretax_amount
    self.unit_refundable_amount =  self.quantity_unit  * (self.unit_pretax_amount * self.tax / 100) #Check if its a good formula and check if tax is percentage or value
  end
end
