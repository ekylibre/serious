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
# == Table: scenario_curves
#
#  created_at               :datetime
#  id                       :integer          not null, primary key
#  initial_amount           :decimal(19, 4)   not null
#  interpolation_method     :string
#  nature                   :string
#  negative_alea_percentage :decimal(19, 4)   not null
#  positive_alea_percentage :decimal(19, 4)   not null
#  reference_id             :integer          not null
#  scenario_id              :integer          not null
#  unit_name                :string
#  updated_at               :datetime
#  variant                  :string
#  variant_indicator_name   :string
#  variant_indicator_unit   :string
#
class ScenarioCurve < ActiveRecord::Base
  extend Enumerize
  enumerize :interpolation_method, in: [:linear, :previous, :following], default: :linear
  enumerize :nature, in: [:variant, :loan_interest, :reference]
  belongs_to :reference, class_name: "ScenarioCurve"
  belongs_to :scenario
  has_many :steps
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :initial_amount, :negative_alea_percentage, :positive_alea_percentage, allow_nil: true
  validates_presence_of :initial_amount, :negative_alea_percentage, :positive_alea_percentage, :reference, :scenario
  #]VALIDATORS]
end
