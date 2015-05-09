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
#  created_at  :datetime
#  currency    :string           not null
#  duration    :integer          not null
#  id          :integer          not null, primary key
#  name        :string           not null
#  turn_nature :string
#  turns_count :string
#  updated_at  :datetime
#
class Scenario < ActiveRecord::Base
  extend Enumerize
  enumerize :currency, in: [:EUR], default: :EUR
  has_many :broadcasts, class_name: "ScenarioBroadcast"
  has_many :curves, class_name: "ScenarioCurve"
  has_many :games
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :duration, allow_nil: true, only_integer: true
  validates_presence_of :currency, :duration, :name
  #]VALIDATORS]

  accepts_nested_attributes_for :broadcasts

end
