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
#  amount                 :decimal(19, 4)   not null
#  created_at             :datetime
#  excess_amount          :decimal(19, 4)   default(0), not null
#  game_id                :integer          not null
#  id                     :integer          not null, primary key
#  insured_id             :integer          not null
#  insurer_id             :integer          not null
#  nature                 :string           not null
#  pretax_amount          :decimal(19, 4)   not null
#  quantity_unit          :string           not null
#  quantity_value         :decimal(19, 4)   not null
#  tax_percentage         :decimal(19, 4)   default(0), not null
#  unit_pretax_amount     :decimal(19, 4)   not null
#  unit_refundable_amount :decimal(19, 4)
#  updated_at             :datetime
#
class Insurance < ActiveRecord::Base
  extend Enumerize
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount, :excess_amount, :pretax_amount, :quantity_value, :tax_percentage, :unit_pretax_amount, :unit_refundable_amount, allow_nil: true
  validates_presence_of :amount, :excess_amount, :insured, :insurer, :nature, :pretax_amount, :quantity_unit, :quantity_value, :tax_percentage, :unit_pretax_amount
  # ]VALIDATORS]
  belongs_to :insured, class_name: 'Participant'
  belongs_to :insurer, class_name: 'Participant'

  enumerize :nature, in: [:harvest]

  before_validation do
    if self.quantity_value && self.unit_pretax_amount && self.tax_percentage
      self.pretax_amount = quantity_value * unit_pretax_amount
      self.amount = pretax_amount * (1 + (tax_percentage / 100))
    end
  end
end
