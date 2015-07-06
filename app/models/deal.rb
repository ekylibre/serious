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
# == Table: deals
#
#  amount      :decimal(19, 4)
#  client_id   :integer          not null
#  created_at  :datetime
#  id          :integer          not null, primary key
#  state       :string
#  supplier_id :integer          not null
#  updated_at  :datetime
#
class Deal < ActiveRecord::Base
  belongs_to :client, class_name: 'Participant'
  belongs_to :supplier, class_name: 'Participant'
  has_many :items, class_name: 'DealItem'
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount, allow_nil: true
  validates_presence_of :client, :supplier
  #]VALIDATORS]


  before_validation do
    self.amount = self.items.sum(:amount)
  end

  before_validation do
    self.state ||= 'draft'
    self.amount ||= 0
  end
  accepts_nested_attributes_for :items
end
