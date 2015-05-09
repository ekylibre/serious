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
# == Table: games
#
#  created_at    :datetime
#  description   :text
#  id            :integer          not null, primary key
#  name          :string           not null
#  planned_at    :datetime
#  scenario_id   :integer
#  state         :string
#  turn_duration :integer
#  turn_nature   :string
#  turns_count   :integer
#  updated_at    :datetime
#
class Game < ActiveRecord::Base
  extend Enumerize
  enumerize :turn_nature, in: [:month], default: :month
  belongs_to :scenario
  has_many :actors
  has_many :farms
  has_many :participations
  has_many :participants
  has_many :turns, class_name: "GameTurn"
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :planned_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :turn_duration, allow_nil: true, only_integer: true
  validates_presence_of :name
  #]VALIDATORS]

  accepts_nested_attributes_for :farms
  accepts_nested_attributes_for :actors

end
