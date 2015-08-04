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
#  amount_round           :integer
#  amplitude_factor       :decimal(19, 4)   default(1), not null
#  code                   :string           not null
#  created_at             :datetime
#  description            :text
#  id                     :integer          not null, primary key
#  initial_amount         :decimal(19, 4)
#  interpolation_method   :string
#  name                   :string           not null
#  nature                 :string           not null
#  negative_alea_amount   :decimal(19, 4)   default(0), not null
#  offset_amount          :decimal(19, 4)   default(0), not null
#  positive_alea_amount   :decimal(19, 4)   default(0), not null
#  reference_id           :integer
#  scenario_id            :integer          not null
#  unit_name              :string
#  updated_at             :datetime
#  variant_indicator_name :string
#  variant_indicator_unit :string
#

# Code must contain variant name if nature is variant.
class ScenarioCurve < ActiveRecord::Base
  extend Enumerize
  enumerize :interpolation_method, in: [:linear, :previous, :following], default: :linear, predicates: { prefix: true }
  enumerize :nature, in: [:variant, :loan_interest, :reference], predicates: { prefix: true }
  belongs_to :reference, class_name: 'ScenarioCurve'
  belongs_to :scenario
  has_many :steps, class_name: 'ScenarioCurveStep', foreign_key: :curve_id, dependent: :delete_all
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount_round, allow_nil: true, only_integer: true
  validates_numericality_of :amplitude_factor, :initial_amount, :negative_alea_amount, :offset_amount, :positive_alea_amount, allow_nil: true
  validates_presence_of :amplitude_factor, :code, :name, :nature, :negative_alea_amount, :offset_amount, :positive_alea_amount, :scenario
  # ]VALIDATORS]
  validates_presence_of :positive_alea_amount, :negative_alea_amount, :amplitude_factor, :offset_amount, :reference, if: :nature_variant?
  validates_uniqueness_of :name, :code, scope: :scenario_id

  accepts_nested_attributes_for :steps

  before_validation do
    self.amount_round ||= 2
    if reference && amplitude_factor
      self.offset_amount ||= 0
      self.positive_alea_amount ||= reference.initial_amount * amplitude_factor * 0.03
      self.negative_alea_amount ||= self.positive_alea_amount
    end
  end

  def generate!
    steps.clear
    if self.nature_variant? && reference = self.reference
      scenario.turns_count.to_i.times do |index|
        turn = index + 1
        amount = reference.turn_amount(turn) * amplitude_factor + self.offset_amount + rand * (self.positive_alea_amount + self.negative_alea_amount) - self.negative_alea_amount
        steps.create!(turn: turn, amount: amount.round(self.amount_round))
      end
    end
  end

  def turn_amount(turn)
    if step = steps.find_by(turn: turn)
      return step.amount
    else # Interpolate
      previous  = steps.where('turn < ?', turn).order(turn: :desc).first
      following = steps.where('turn > ?', turn).order(:turn).first
      unless previous || following
        fail 'Cannot interpolate amount with no steps...'
      end
      if self.interpolation_method_linear?
        if previous && following
          # y = a * x + b
          a = (following.amount - previous.amount) / (following.turn - previous.turn)
          b = previous.amount - a * previous.turn
          return (a * turn + b)
        else
          return (previous ? previous.amount : following.amount)
        end
      elsif self.interpolation_method_previous?
        return (previous ? previous.amount : following.amount)
      elsif self.interpolation_method_following?
        return (following ? following.amount : previous.amount)
      end
    end
  end
end
