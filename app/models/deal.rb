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
#  amount        :decimal(19, 4)   default(0), not null
#  created_at    :datetime
#  customer_id   :integer          not null
#  game_id       :integer          not null
#  id            :integer          not null, primary key
#  invoiced_at   :datetime
#  pretax_amount :decimal(19, 4)   default(0), not null
#  state         :string           not null
#  supplier_id   :integer          not null
#  updated_at    :datetime
#

# A deal is a sale or a purchase between a customer and a supplier.
class Deal < ActiveRecord::Base
  extend Enumerize
  belongs_to :game
  belongs_to :customer, class_name: 'Participant'
  belongs_to :supplier, class_name: 'Participant'
  has_many :items, class_name: 'DealItem'
  enumerize :state, in: [:draft, :invoice], default: :draft, predicates: true

  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :invoiced_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :amount, :pretax_amount, allow_nil: true
  validates_presence_of :amount, :customer, :game, :pretax_amount, :state, :supplier
  # ]VALIDATORS]

  delegate :name, to: :supplier, prefix: true
  delegate :name, to: :customer, prefix: true

  accepts_nested_attributes_for :items

  alias_attribute :number, :id

  before_validation do
    update_totals
    self.state ||= 'draft'
  end

  # Sets totals in columns without saving
  def update_totals
    self.pretax_amount = items.sum(:pretax_amount)
    self.amount = items.sum(:amount)
  end

  # Update totals and save! it
  def update_totals!
    update_totals
    save!
  end

  # Confirm deal and transfer data to foreign apps
  def checkout
    items_list = items.collect do |item|
      item.attributes.symbolize_keys.slice(:product_id, :variant, :tax, :unit_pretax_amount, :unit_amount, :pretax_amount, :amount, :quantity).delete_if { |_k, v| v.blank? }
    end

    invoiced_on = customer.current_date
    # Send data to customer
    # For a customer, a deal is a purchase
    if customer.application_url?
      customer.post('/purchases', # invoiced_on: invoiced_on,
                    supplier: {
                      last_name: supplier.name,
                      code: supplier.code
                    },
                    items: items_list)
    end

    # Send data to supplier
    # For a supplier, a deal is a sale
    if supplier.application_url?
      supplier.post('/sales', # invoiced_on: invoiced_on,
                    customer: {
                      last_name: customer.name,
                      code: customer.code
                    },
                    items: items_list)
    end

    update_column(:state, :invoice)
  end

  # Cancel deal and transfer order to foreign apps
  def cancel
    fail NotImplementedError
  end
end
