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
# == Table: contract_natures
#
#  amount         :decimal(19, 4)   not null
#  contract_count :integer
#  contract_quota :integer
#  contractor_id  :integer          not null
#  description    :text
#  id             :integer          not null, primary key
#  release_turn   :integer          not null
#  title          :string
#  variant        :string
#
class ContractNature < ActiveRecord::Base
  has_many :contracts
  belongs_to :contractor
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :contract_quota, :release_turn, allow_nil: true, only_integer: true
  validates_numericality_of :amount, allow_nil: true
  validates_presence_of :amount, :release_turn
  #]VALIDATORS]
end
