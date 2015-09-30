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
# == Table: deal_items
#
#  amount             :decimal(19, 4)   not null
#  catalog_item_id    :integer
#  created_at         :datetime
#  deal_id            :integer          not null
#  id                 :integer          not null, primary key
#  pretax_amount      :decimal(19, 4)   not null
#  product            :text
#  product_id         :integer
#  quantity           :decimal(19, 4)   not null
#  tax                :string           not null
#  unit_amount        :decimal(19, 4)   not null
#  unit_pretax_amount :decimal(19, 4)   not null
#  updated_at         :datetime
#  variant            :string           not null
#

require 'serious'

class DealItem < ActiveRecord::Base
  extend Enumerize
  enumerize :tax, in: Serious::TAXES.keys
  belongs_to :deal
  belongs_to :catalog_item
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :amount, :pretax_amount, :quantity, :unit_amount, :unit_pretax_amount, allow_nil: true
  validates_presence_of :amount, :deal, :pretax_amount, :quantity, :tax, :unit_amount, :unit_pretax_amount, :variant
  # ]VALIDATORS]
  validates_presence_of :tax
  serialize :product

  delegate :update_totals!, to: :deal

  after_save :update_totals!
  after_destroy :update_totals!

  after_initialize do
    self.quantity ||= 0
    self.unit_amount ||= 0
  end

  before_validation do
    if catalog_item
      self.variant = catalog_item.variant
      self.unit_pretax_amount = catalog_item.pretax_amount(Game.find(deal.game_id))
      self.tax = catalog_item.tax
    end
    if Serious::TAXES[tax]
      self.unit_amount = (unit_pretax_amount * (100 + Serious::TAXES[tax]) / 100.0).round(2)
      self.pretax_amount = unit_pretax_amount * self.quantity
      self.amount = (pretax_amount * (100 + Serious::TAXES[tax]) / 100.0).round(2)
      self.pretax_amount = pretax_amount.round(2)
    end
  end

  def variant_name
    variant.to_s.humanize
  end
end
