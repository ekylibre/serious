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
#  access_token  :string
#  created_at    :datetime
#  description   :text
#  id            :integer          not null, primary key
#  launched_at   :datetime
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

require 'serious/slave'

class Game < ActiveRecord::Base
  extend Enumerize
  enumerize :state, in: [:planned, :in_preparation, :ready, :running, :paused, :stopped, :finished], default: :planned, predicates: true
  enumerize :turn_nature, in: [:month], default: :month
  belongs_to :scenario
  has_many :actors, -> { actor }, class_name: 'Participant'
  has_many :broadcasts, through: :scenario
  has_many :deals
  has_many :farms, -> { farm }, class_name: 'Participant'
  has_many :issues, through: :scenario
  has_many :organizer_participations, -> { where(nature: :organizer) }, class_name: 'Participation'
  has_many :organizers, through: :organizer_participations, source: :user
  has_many :participations
  has_many :participants
  has_many :turns, -> { order(:number) }, class_name: 'GameTurn', dependent: :destroy, counter_cache: false
  has_many :users, through: :participations
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :launched_at, :planned_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :map_height, :map_width, :turn_duration, allow_nil: true, only_integer: true
  validates_presence_of :name
  # ]VALIDATORS]
  validates_presence_of :planned_at, :turn_duration, :turns_count, :turn_nature, :state

  scope :active, -> { where(state: 'running') }

  delegate :historic, :started_on, to: :scenario

  accepts_nested_attributes_for :participants

  before_validation do
    self.planned_at ||= Time.now
    self.access_token ||= Devise.friendly_token
    if scenario
      self.turn_nature ||= scenario.turn_nature
      self.turns_count ||= scenario.turns_count
    end
  end

  before_update do
    old_record = self.class.find_by(id: id)
    turns.where(duration: old_record.turn_duration).update_all(duration: turn_duration)
  end

  after_save do
    started_at = launched_at || planned_at
    count = self.turns_count
    self.turns_count.times do |index|
      turn = turns.find_or_initialize_by(number: index + 1)
      turn.duration ||= turn_duration
      turn.started_at = started_at
      turn.save!
      started_at = turn.stopped_at
    end
    turns.where('number > ?', count).destroy_all
  end

  after_save do
    load! if self.ready? || self.running?
  end

  def trigger(issue)
    participants.find_each do |participant|
      next unless participant.application_url?
      participant.post('/issues',
                       name: issue.name,
                       nature: issue.nature,
                       description: issue.description,
                       # observed_at: current_date,
                       target: {
                         variety: issue.variety,
                         maximal_age: issue.maximal_age,
                         minimal_age: issue.minimal_age,
                         coordinates_nature: issue.coordinates_nature,
                         coordinates: issue.coordinates
                       },
                       damage: {
                         impacted_indicator_name: issue.impacted_indicator_name,
                         impacted_indicator_value: issue.impacted_indicator_value,
                         destruction_percentage: issue.destruction_percentage
                       }
                      )
    end
  end

  def current_date
    current_turn.finished_on
  end

  class << self
    def import(file)
      hash = YAML.load_file(file).deep_symbolize_keys
      attributes = hash.slice(:name, :description, :planned_at, :turns_count, :turn_nature, :turn_duration, :map_width, :map_height)
      # puts Scenario.find_by(code: hash[:scenario]).inspect
      unless attributes[:planned_at]
        attributes[:planned_at] = Time.now
        attributes[:state] ||= :planned
      end
      attributes[:turn_duration] ||= 30
      attributes[:turn_nature] ||= :month
      attributes[:scenario] = Scenario.find_by(code: hash[:scenario]) if hash[:scenario]
      game = create!(attributes)

      hash[:farms].each do |code, farm|
        game.farms.create! farm.slice(:name, :borrower, :lender, :customer, :supplier, :insured, :insurer, :subcontractor, :contractor, :zone_x, :zone_y, :zone_width, :zone_height, :present, :stand_number, :application_url).merge(code: code)
      end

      hash[:actors].each do |code, actor|
        attributes = actor.slice(:name, :borrower, :lender, :customer, :supplier, :insured, :insurer, :subcontractor, :contractor, :zone_x, :zone_y, :zone_width, :zone_height, :present, :stand_number).merge(code: code)
        attributes[:catalog_items_attributes] = actor[:catalog_items] if actor[:catalog_items]
        game.actors.create! attributes
      end

      hash[:participations].each do |participation|
        game.participations.create!(participation.merge(participant: game.participants.find_by(code: participation[:participant]), user: User.find_by(email: participation[:user])))
      end if hash[:participations]
    end
  end

  # Returns current turn from now
  def current_turn(at = nil)
    at ||= Time.now
    turns.at(at).first
  end

  def last_turn
    turns.last
  end

  def reference_curves
    scenario.curves.where(nature: 'reference')
  end

  def can_prepare?
    self.planned? || self.stopped? || self.finished?
  end

  def can_edit?
    self.planned? || self.stopped? || self.finished?
  end

  def can_start?
    self.ready?
  end

  def can_stop?
    self.running?
  end

  def really_running?
    self.running? && current_turn
  end

  def elapsed_duration
    return 0 unless launched_at
    Time.now - launched_at
  end

  def total_duration
    turns.sum(:duration) * 60
  end

  # Estimate delay before effective launch
  def launch_delay
    farms.where('LENGTH(TRIM(application_url)) > 0').count * 0.3
  end

  def api_url
    Serious::Slave.url_for("/api/v1/games/#{id}")
  end

  def prepare!
    Serious::Slave.exec("bin/rake seriously:prepare GAME_URL=#{api_url} TOKEN=#{Shellwords.escape(self.access_token)}")
  end

  # Start the game
  def start!
    now = Time.now + launch_delay
    self.launched_at = now
    save
    fail 'Cannot start this game' unless self.ready?
    Serious::Slave.exec("bin/rake seriously:start GAME_URL=#{api_url} TOKEN=#{Shellwords.escape(self.access_token)}")
    update_column(:state, :running)
  end

  # Cancel the game
  def cancel!
    update_column(:state, :planned)
  end

  # Stop the game
  def stop!
    Serious::Slave.exec("bin/rake seriously:stop GAME_URL=#{api_url} TOKEN=#{Shellwords.escape(self.access_token)}")
    update_column(:state, :stopped)
  end

  # Creates Ekylibre instances and load them
  def load!
    turns_list = turns.map do |turn|
      { number: turn.number, started_at: turn.started_at,
        stopped_at: turn.stopped_at, frozen_at: turn.frozen_at,
        inside: {
          started_at: turn.inside_started_at,
          stopped_at: turn.inside_stopped_at
        }
      }
    end
    participants.find_each do |farm|
      next unless farm.application_url?
      farm.patch('/game', name: name,
                          id: id,
                          turns: turns_list)
    end
  end

  # Produce hash of configuration information of game
  def configuration(options = {})
    conf = {}.merge(options)
    conf[:name] = name
    conf[:description] = description if self.description?
    conf[:planned_at] = self.planned_at if self.planned_at?
    conf[:farms] = []
    # Farms
    farms.reorder(:name).includes(:users).find_each do |farm|
      users = []
      farm.users.find_each do |user|
        users << {
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          password: (Rails.env.development? ? '12345678' : Devise.friendly_token)
        }
      end
      conf[:farms] << {
        tenant: farm.tenant,
        name: farm.name,
        token: farm.access_token,
        users: users
      }
    end
    # TODO : Other guys
    conf
  end
end
