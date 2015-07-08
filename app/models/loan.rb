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
#  amount               :decimal(19, 4)
#  borrower_id          :integer          not null
#  created_at           :datetime
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
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount, :insurance_percentage, :interest_percentage, allow_nil: true
  validates_presence_of :borrower, :insurance_percentage, :interest_percentage, :lender
  #]VALIDATORS]

  after_initialize :init

  before_validation do
    percentage_interest = self.interest_percentage / 100 + 1
    percentage_insurance = self.insurance_percentage / 100
    amount_total = self.amount * percentage_interest + self.amount * percentage_insurance

    self.turns_count = amount_total / 10000
    if amount_total % 10000 !=0
      self.turns_count += 1
    end
  end

  def init
    self.interest_percentage ||= 3
    self.insurance_percentage ||= 0.3

  end
end
