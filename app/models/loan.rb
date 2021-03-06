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
# == Table: loans
#
#  amount               :decimal(19, 4)   not null
#  borrower_id          :integer          not null
#  created_at           :datetime
#  game_id              :integer          not null
#  id                   :integer          not null, primary key
#  insurance_percentage :decimal(19, 4)   not null
#  interest_percentage  :decimal(19, 4)   not null
#  lender_id            :integer          not null
#  turns_count          :integer          not null
#  updated_at           :datetime
#
class Loan < ActiveRecord::Base
  belongs_to :borrower, class_name: 'Participant'
  belongs_to :lender, class_name: 'Participant'
  belongs_to :game
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount, :insurance_percentage, :interest_percentage, allow_nil: true
  validates_presence_of :amount, :borrower, :game, :insurance_percentage, :interest_percentage, :lender
  # ]VALIDATORS]

  validates :game, presence: true
  delegate :name, to: :lender, prefix: true
  delegate :name, to: :borrower, prefix: true

  before_validation do
    self.interest_percentage ||= 3
    self.insurance_percentage ||= 0.3

    percentage_interest = self.interest_percentage / 100 + 1
    percentage_insurance = self.insurance_percentage / 100
    amount_total = amount * percentage_interest + amount * percentage_insurance
    self.turns_count = amount_total / 10_000
    self.turns_count += 1 if amount_total % 10_000 != 0

    self.game = lender.game
    self.created_at ||= game.current_date
  end

  after_validation do
    if borrower.application_url?
      borrower.post('/loans',
                    lender: {
                      last_name: lender.name,
                      code: lender.code
                    },
                    amount: amount,
                    insurance_percentage: insurance_percentage,
                    duration: turns_count,
                    interest_percentage: insurance_percentage,
                    started_on: created_at,
                    loan_name: " #{borrower.name} - #{amount}€ (#{created_at})"
                   )
    end
  end

  def number
    "L#{id}"
  end
end
