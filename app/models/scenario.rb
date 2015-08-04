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
#  code        :string           not null
#  created_at  :datetime
#  currency    :string           not null
#  description :text
#  id          :integer          not null, primary key
#  name        :string           not null
#  turn_nature :string
#  turns_count :string           not null
#  updated_at  :datetime
#

class Scenario < ActiveRecord::Base
  extend Enumerize
  enumerize :currency, in: [:EUR], default: :EUR
  enumerize :turn_nature, in: [:month], default: :month
  has_many :broadcasts, -> { order(:release_turn) }, class_name: 'ScenarioBroadcast'
  has_many :curves, class_name: 'ScenarioCurve'
  has_many :games
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_presence_of :code, :currency, :name
  # ]VALIDATORS]
  validates_uniqueness_of :name, :code

  accepts_nested_attributes_for :broadcasts
  accepts_nested_attributes_for :curves

  class << self
    def import(file)
      hash = YAML.load_file(file).deep_symbolize_keys
      return if find_by(name: hash[:name]) || find_by(code: hash[:code])
      scenario = create!(hash.slice(:code, :name, :description, :turn_nature, :turns_count, :currency))
      if hash[:broadcasts]
        hash[:broadcasts].each do |b|
          scenario.broadcasts.create!(b.slice(:name, :content, :release_turn))
        end
      end
      if hash[:curves]
        hash[:curves].each do |code, attributes|
          attributes[:code] = code
          attributes[:reference] = scenario.curves.find_by(code: attributes[:reference]) if attributes[:reference]
          curve = scenario.curves.create!(attributes.slice(:nature, :name, :code, :description, :unit_name, :initial_amount, :interpolation_method, :negative_alea_amount, :positive_alea_amount, :amplitude_factor, :offset_amount, :amount_round, :variant_indicator_name, :variant_indicator_unit, :reference))
          if attributes[:steps]
            attributes[:steps].each do |step|
              curve.steps.create!(step.slice(:turn, :amount))
            end
          else
            curve.generate!
          end
          print '#'
        end
      end
    end
  end
end
