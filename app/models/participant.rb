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
#  access_token      :string
#  application_url   :string
#  borrower          :boolean          default(FALSE), not null
#  closed            :boolean          default(FALSE), not null
#  code              :string           not null
#  contractor        :boolean          default(FALSE), not null
#  created_at        :datetime
#  customer          :boolean          default(FALSE), not null
#  game_id           :integer          not null
#  id                :integer          not null, primary key
#  insured           :boolean          default(FALSE), not null
#  insurer           :boolean          default(FALSE), not null
#  lender            :boolean          default(FALSE), not null
#  logo_content_type :string
#  logo_file_name    :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  name              :string           not null
#  nature            :string           not null
#  present           :boolean          default(FALSE), not null
#  stand_number      :string
#  subcontractor     :boolean          default(FALSE), not null
#  supplier          :boolean          default(FALSE), not null
#  tenant            :string
#  updated_at        :datetime
#  zone_height       :integer
#  zone_width        :integer
#  zone_x            :integer
#  zone_y            :integer
#

class Participant < ActiveRecord::Base
  extend Enumerize
  enumerize :nature, in: [:farm, :actor], predicates: true
  belongs_to :game
  has_many :catalog_items, inverse_of: :participant
  has_many :participations
  has_many :ratings, -> { order(:rated_at) }, class_name: 'ParticipantRating'
  has_many :users, through: :participations
  has_many :sales,      class_name: 'Deal', foreign_key: :supplier_id
  has_many :purchases,  class_name: 'Deal', foreign_key: :customer_id
  has_many :borrowings, class_name: 'Loan', foreign_key: :borrower_id
  has_many :lendings,   class_name: 'Loan', foreign_key: :lender_id
  has_many :subcontractings, class_name: 'Contract', foreign_key: :contractor_id
  has_many :contractings,    class_name: 'Contract', foreign_key: :subcontractor_id

  has_attached_file :logo, styles: {
    identity: ['200x200#', :png]
  }

  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :logo_updated_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :logo_file_size, :zone_height, :zone_width, :zone_x, :zone_y, allow_nil: true, only_integer: true
  validates_inclusion_of :borrower, :closed, :contractor, :customer, :insured, :insurer, :lender, :present, :subcontractor, :supplier, in: [true, false]
  validates_presence_of :code, :game, :name, :nature
  # ]VALIDATORS]
  validates_uniqueness_of :name, scope: :game_id
  validates :tenant, uniqueness: true, if: :farm?
  validates_attachment_content_type :logo, content_type: /image/

  scope :actor, -> { where(nature: 'actor') }
  scope :farm,  -> { where(nature: 'farm') }

  accepts_nested_attributes_for :catalog_items, allow_destroy: true

  delegate :current_date, to: :game

  before_validation do
    if farm?
      self.borrower = true
      self.subcontractor = true
      self.customer = true
      self.insured = true
      self.tenant ||= code
      self.access_token ||= Devise.friendly_token
      if self.application_url.blank? && Serious::Slave.domain
        self.application_url = "http://#{self.code}.#{Serious::Slave.domain}"
      end
    end
  end

  def products
    if application_url
      get('/products').map(&:symbolize_keys)
    elsif !catalog_items.nil?
      catalog_items.collect do |item|
        {
          name: item.variant_name,
          variant: item.variant,
          catalog_item_id: item.id
        }
      end
    else
      []
    end
  end

  validate do
    errors.add(:lender, :invalid) if lender if farm?
  end

  def unique_name
    "serious_#{id}"
  end

  def unique_id
    "s#{id.to_s(36)}"
  end

  def number
    I18n.transliterate(name.mb_chars.downcase).gsub(/[^a-zA-Z0-9]/, '').to_i(36)
  end

  def color
    val = number
    k = 10
    l = 16
    m = 2
    offset = 64
    r = 17
    g = 13
    b = 23
    c = ''
    c << ((val * r / m).modulo(k) * l + offset).to_s(16).rjust(2, '0')
    c << ((val * g / m).modulo(k) * l + offset).to_s(16).rjust(2, '0')
    c << ((val * b / m).modulo(k) * l + offset).to_s(16).rjust(2, '0')
    c
  end

  def abbreviation
    I18n.transliterate(name).gsub(/[^a-zA-Z0-9@\s]/, '').split(/\s+/).delete_if { |w| %w(de des du la le les au aux).include?(w) }[0..1].map { |w| w[0..0] }.join.upcase
  end

  def affairs_with(other)
    list = []
    list += sales.where(customer: other).to_a
    list += purchases.where(supplier: other).to_a
    list += borrowings.where(lender: other).to_a
    list += lendings.where(borrower: other).to_a
    list += subcontractings.where(subcontractor: other).to_a
    list += contractings.where(contractor: other).to_a
    list
  end

  def transfer_quality_rating
    contracts = self.contractings.where(state: [:cancelled, :executed])
    average = 2 * (contracts.sum(:quality_rating).to_f || 0.0) / contracts.count
    post("/guides/quality", {rating: average})
  end

  def domain
    application_url.gsub(/^https?:\/\//, '').gsub(/\:\d+$/, '')
  end

  # Perform a POST access on REST API of foreign app
  def post(path, params = {}, options = {})
    options[:content_type] ||= :json
    options[:Authorization] = "simple-token #{self.access_token}"
    RestClient.post(request_url(path), params.to_json, options)
  end

  # Perform a POST access on REST API of foreign app
  def patch(path, params = {}, options = {})
    options[:content_type] ||= :json
    options[:Authorization] = "simple-token #{self.access_token}"
    RestClient.patch(request_url(path), params.to_json, options)
  end

  # Perform a GET access on REST API of foreign app
  def get(path, params = {}, options = {})
    options[:accept] ||= :json
    options[:content_type] ||= :json
    options[:params] = params
    options[:Authorization] = "simple-token #{self.access_token}"
    JSON.parse RestClient.get(request_url(path), options)
  end

  def request_url(path = nil)
    "#{application_url}/seriously/v1#{path}"
  end
end
