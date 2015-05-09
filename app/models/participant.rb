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
# == Table: participants
#
#  borrower      :boolean          default(FALSE), not null
#  client        :boolean          default(FALSE), not null
#  contractor    :boolean          default(FALSE), not null
#  created_at    :datetime
#  game_id       :integer          not null
#  historic_id   :integer
#  id            :integer          not null, primary key
#  lender        :boolean          default(FALSE), not null
#  name          :string           not null
#  subcontractor :boolean          default(FALSE), not null
#  supplier      :boolean          default(FALSE), not null
#  type          :string
#  updated_at    :datetime
#
class Participant < ActiveRecord::Base
  belongs_to :game
  has_many :catalog_items
  has_many :participations
  has_many :users, through: :participations
  has_many :sales,      class_name: "Deal", foreign_key: :supplier_id
  has_many :purchases,  class_name: "Deal", foreign_key: :client_id
  has_many :borrowings, class_name: "Loan", foreign_key: :borrower_id
  has_many :lendings,   class_name: "Loan", foreign_key: :lender_id
  has_many :subcontractings, class_name: "Contract", foreign_key: :originator_id
  has_many :contractings,    class_name: "Contract", foreign_key: :subcontractor_id
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_inclusion_of :borrower, :client, :contractor, :lender, :subcontractor, :supplier, in: [true, false]
  validates_presence_of :game, :name
  #]VALIDATORS]
  validates_uniqueness_of :name, scope: :game_id

end
