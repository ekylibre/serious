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
# == Table: contracts
#
#  conditions       :text
#  contractor_id    :integer          not null
#  created_at       :datetime
#  delay            :string
#  game_id          :integer          not null
#  id               :integer          not null, primary key
#  name             :string
#  quality_rating   :integer
#  quantity         :string
#  state            :string           not null
#  subcontractor_id :integer          not null
#  updated_at       :datetime
#  variant          :string           not null
#

# A contract is used between a contractor who propose the contract and
# the subcontractor who accepts to execute the contract.
class Contract < ActiveRecord::Base
  extend Enumerize
  enumerize :state, in: [:active, :executed, :cancelled], default: :active, predicates: true
  belongs_to :contractor,    class_name: 'Participant'
  belongs_to :subcontractor, class_name: 'Participant'
  belongs_to :game
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :quality_rating, allow_nil: true, only_integer: true
  validates_presence_of :contractor, :game, :state, :subcontractor, :variant
  # ]VALIDATORS]

  before_validation do
    self.quality_rating ||= 0
  end

  def number
    id
  end

  after_save do
    subcontractor.transfer_quality_rating
  end

end
