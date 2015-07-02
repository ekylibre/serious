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
# == Table: catalog_items
#
#  created_at                 :datetime
#  id                         :integer          not null, primary key
#  nature                     :boolean
#  negative_margin_percentage :decimal(19, 4)   not null
#  participant_id             :integer          not null
#  positive_margin_percentage :decimal(19, 4)   not null
#  quota                      :decimal(19, 4)   not null
#  updated_at                 :datetime
#  variant                    :string           not null
#
class CatalogItem < ActiveRecord::Base
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :negative_margin_percentage, :positive_margin_percentage, :quota, allow_nil: true
  validates_presence_of :negative_margin_percentage, :positive_margin_percentage, :quota, :variant
  #]VALIDATORS]
  
  def amount
    10
  end

  def pretax_amount
    8
  end
end
