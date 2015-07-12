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
# == Table: games
#
#  created_at    :datetime
#  description   :text
#  id            :integer          not null, primary key
#  map_height    :integer
#  map_width     :integer
#  name          :string           not null
#  planned_at    :datetime
#  scenario_id   :integer
#  state         :string
#  turn_duration :integer
#  turn_nature   :string
#  turns_count   :integer
#  updated_at    :datetime
#
class Game < ActiveRecord::Base
  extend Enumerize
  enumerize :state, in: [:planned, :running, :paused, :finished], default: :planned, predicates: true
  enumerize :turn_nature, in: [:month], default: :month
  belongs_to :scenario
  has_many :actors
  has_many :broadcasts, through: :scenario
  has_many :farms
  has_many :organizer_participations, -> { where(nature: :organizer) }, class_name: "Participation"
  has_many :organizers, through: :organizer_participations, source: :user
  has_many :participations
  has_many :participants
  has_many :turns, class_name: "GameTurn", dependent: :destroy, counter_cache: false
  has_many :users, through: :participations
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :planned_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :map_height, :map_width, :turn_duration, allow_nil: true, only_integer: true
  validates_presence_of :name
  #]VALIDATORS]
  validates_presence_of :planned_at, :turn_duration, :turn_nature, :state

  scope :active, -> { where(state: "running") }

  accepts_nested_attributes_for :farms
  accepts_nested_attributes_for :actors

  before_validation do
    self.planned_at ||= Time.now
    if self.scenario
      self.turn_nature = self.scenario.turn_nature
      self.turns_count = self.scenario.turns_count
    end
  end

  after_save do
    self.turns.clear
    if self.turns_count
      started_at = self.planned_at
      self.turns_count.times do |index|
        stopped_at = started_at + self.turn_duration.minutes
        self.turns.create!(number: index + 1, started_at: started_at, stopped_at: stopped_at)
        started_at = stopped_at
      end
    end
  end

  class << self

    def import(file)
      hash = YAML.load_file(file).deep_symbolize_keys
      attributes = hash.slice(:name, :description, :planned_at, :turns_count, :turn_nature, :turn_duration, :map_width, :map_height)
      # puts Scenario.find_by(code: hash[:scenario]).inspect
      unless attributes[:planned_at]
        attributes[:planned_at] = Time.now
        attributes[:state] ||= :running
      end
      attributes[:turn_duration] ||= 30
      attributes[:turn_nature] ||= :month
      attributes[:scenario] = Scenario.find_by(code: hash[:scenario]) if hash[:scenario]
      game = create!(attributes)

      hash[:farms].each do |code, farm|
        historic = farm[:historic].blank? ? nil : Historic.find_by(code: farm[:historic])
        game.farms.create! farm.slice(:name, :borrower, :lender, :customer, :supplier, :subcontractor, :contractor, :zone_x, :zone_y, :zone_width, :zone_height, :present, :stand_number).merge(code: code, historic: historic)
      end

      hash[:actors].each do |code, actor|
        attributes = actor.slice(:name, :borrower, :lender, :customer, :supplier, :subcontractor, :contractor, :zone_x, :zone_y, :zone_width, :zone_height, :present, :stand_number).merge(code: code)
        attributes[:catalog_items_attributes] = actor[:catalog_items] if actor[:catalog_items]
        game.actors.create! attributes
      end

      hash[:participations].each do |participation|
        game.participations.create!(participation.merge(participant: game.participants.find_by(code: participation[:participant]), user: User.find_by(email: participation[:user])))
      end if hash[:participations]
    end

  end

  def started?
    Time.now >= self.planned_at
  end

  # Returns current turn from now
  def current_turn(at = nil)
    at ||= Time.now
    self.turns.at(at).first
  end


  def reference_curves
    self.scenario.curves.where(nature: "reference")
  end

  # Launch the game
  # Creates Ekylibre instances and load them with their historics
  def load
    self.participants.each do |participant|
      participant.load
    end
  end

end
