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
#  amount           :decimal(19, 4)   not null
#  created_at       :datetime
#  delivery_turn    :integer          not null
#  id               :integer          not null, primary key
#  originator_id    :integer          not null
#  quantity         :decimal(19, 4)   not null
#  release_turn     :integer          not null
#  subcontractor_id :integer
#  updated_at       :datetime
#  variant          :string
#
class Contract < ActiveRecord::Base
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :delivery_turn, :release_turn, allow_nil: true, only_integer: true
  validates_numericality_of :amount, :quantity, allow_nil: true
  validates_presence_of :amount, :delivery_turn, :quantity, :release_turn
  #]VALIDATORS]
end
