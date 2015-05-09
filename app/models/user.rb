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
# == Table: users
#
#  created_at             :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :integer          not null, primary key
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  updated_at             :datetime
#
class User < ActiveRecord::Base
  has_many :participations
  has_many :participants, through: :participations
  has_many :games, through: :participations

  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :current_sign_in_at, :last_sign_in_at, :remember_created_at, :reset_password_sent_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_presence_of :email, :encrypted_password
  #]VALIDATORS]
  validates_presence_of :first_name, :last_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  def name
    "#{self.first_name} #{self.last_name}"
  end

  # Returns the URL of the avatar of the user
  def avatar_url(options = {})
    size = options[:size] || 200
    hash = Digest::MD5.hexdigest(self.email)
    options[:default] = :retro unless options.has_key? :default
    return "https://secure.gravatar.com/avatar/#{hash}?size=#{size}&d=#{options[:default]}"
  end

end
