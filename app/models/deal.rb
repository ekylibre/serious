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
#  created_at  :datetime
#  customer_id :integer          not null
#  id          :integer          not null, primary key
#  state       :string
#  supplier_id :integer          not null
#  updated_at  :datetime
#

# A deal is a sale or a purchase between a customer and a supplier.
class Deal < ActiveRecord::Base
  extend Enumerize
  belongs_to :customer, class_name: 'Participant'
  belongs_to :supplier, class_name: 'Participant'
  has_many :items, class_name: 'DealItem'
  enumerize :state, in: [:draft, :invoice], default: :draft

  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount, allow_nil: true
  validates_presence_of :customer, :supplier
  # ]VALIDATORS]

  delegate :name, to: :supplier, prefix: true
  delegate :name, to: :customer, prefix: true

  accepts_nested_attributes_for :items

  before_validation do
    self.amount = items.sum(:amount)
  end

  before_validation do
    self.state ||= 'draft'
    self.amount ||= 0
  end

  def checkout
    items = self.items.collect do |item|
      item.attributes.slice(:variant, :tax, :unit_pretax_amount, :unit_amount, :pretax_amount, :amount, :quantity)
    end

    # Send data to customer
    # For a customer, a deal is a purchase
    if self.customer.application_url?
      self.customer.post("/purchases", {
                           supplier: {
                             last_name: supplier.name,
                             code: supplier.code
                           },
                           items: items
                         })
    end

    # Send data to supplier
    # For a supplier, a deal is a sale
    if self.supplier.application_url?
      self.supplier.post("/sales", {
                           customer: {
                             last_name: customer.name,
                             code: customer.code
                           },
                           items: items
                         })
    end

    update_column(:state, :invoice)
  end

  def number
    "D#{id}"
  end
end
