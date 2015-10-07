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
#  code                  :string           not null
#  created_at            :datetime
#  currency              :string           not null
#  description           :text
#  historic_content_type :string
#  historic_file_name    :string
#  historic_file_size    :integer
#  historic_updated_at   :datetime
#  id                    :integer          not null, primary key
#  monthly_expenses      :json
#  name                  :string           not null
#  started_on            :date             not null
#  turn_nature           :string
#  turns_count           :string           not null
#  updated_at            :datetime
#

class Scenario < ActiveRecord::Base
  extend Enumerize
  enumerize :currency, in: [:EUR], default: :EUR
  enumerize :turn_nature, in: [:month], default: :month
  has_many :broadcasts, -> { order(:release_turn) }, class_name: 'ScenarioBroadcast'
  has_many :curves, class_name: 'ScenarioCurve'
  has_many :games
  has_many :issues, class_name: 'ScenarioIssue'
  has_attached_file :historic

  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_date :started_on, allow_blank: true, on_or_after: Date.civil(1, 1, 1)
  validates_datetime :historic_updated_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :historic_file_size, allow_nil: true, only_integer: true
  validates_presence_of :code, :currency, :name, :started_on
  # ]VALIDATORS]
  validates_uniqueness_of :name, :code
  validates_attachment_content_type :historic, content_type: 'application/zip'

  accepts_nested_attributes_for :broadcasts
  accepts_nested_attributes_for :curves

  before_validation do
    self.started_on ||= Date.civil(2015, 9, 1)
  end

  def value_of(variant, turn)
    curve = curves.find_by(code: variant)
    if curve
      step = curve.steps.find_by(turn: turn)
      return step.amount if step
    end
    nil
  end

  class << self
    def import(file)
      hash = YAML.load_file(file).deep_symbolize_keys
      return if find_by(name: hash[:name]) || find_by(code: hash[:code])
      scenario = create!(hash.slice(:code, :name, :description, :turn_nature, :turns_count, :currency, :monthly_expenses))
      if hash[:historic]
        historic = Pathname.new(file).dirname.join(hash[:historic])
        if historic.exist?
          f = File.open(historic)
          scenario.historic = f
          scenario.save!
          f.close
        else
          puts "Cannot find #{historic.to_s.blue} (#{hash[:historic].inspect.red})"
        end
      end
      if hash[:broadcasts]
        hash[:broadcasts].each do |b|
          scenario.broadcasts.create!(b.slice(:name, :content, :release_turn))
        end
      end
      if hash[:issues]
        hash[:issues].each do |b|
          scenario.issues.create!(b.slice(:name, :description, :coordinates_nature, :coordinates, :trigger_turn, :nature, :variety, :minimal_age, :maximal_age, :impacted_indicator_name, :impacted_indicator_value, :destruction_percentage))
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
