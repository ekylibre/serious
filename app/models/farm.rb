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
#  borrower          :boolean          default(FALSE), not null
#  client            :boolean          default(FALSE), not null
#  code              :string
#  contractor        :boolean          default(FALSE), not null
#  created_at        :datetime
#  game_id           :integer          not null
#  historic_id       :integer
#  id                :integer          not null, primary key
#  lender            :boolean          default(FALSE), not null
#  logo_content_type :string
#  logo_file_name    :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  name              :string           not null
#  present           :boolean          default(FALSE), not null
#  stand_number      :string
#  subcontractor     :boolean          default(FALSE), not null
#  supplier          :boolean          default(FALSE), not null
#  type              :string
#  updated_at        :datetime
#  zone_height       :integer
#  zone_width        :integer
#  zone_x            :integer
#  zone_y            :integer
#
class Farm < Participant
  belongs_to :historic

  
end
