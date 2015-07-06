class AddBase < ActiveRecord::Migration
  def change

    # Start of everything: 01/09/2015

    create_table :historics do |t|
      t.string     :name,        null: false
      t.string     :code
      t.string     :currency,    null: false
      t.text       :description
      t.timestamps
    end

    create_table :scenarios do |t|
      t.string     :name,        null: false
      t.string     :code
      t.string     :currency,    null: false
      t.string     :turn_nature              # month
      t.string     :turns_count, null: false # 12 seems to be minimum
      t.text       :description
      t.timestamps
    end

    create_table :scenario_broadcasts do |t|
      t.references :scenario,     null: false, index: true
      t.string     :name,         null: false
      t.integer    :release_turn, null: false
      t.text       :content
      t.timestamps
    end

    create_table :scenario_curves do |t|
      t.references :scenario,    null: false, index: true
      t.string     :nature # variant, loan_interest, reference
      t.string     :name
      t.string     :unit_name
      t.string     :variant
      t.string     :variant_indicator_name
      t.string     :variant_indicator_unit
      t.string     :interpolation_method  # linear, previous, next
      t.text       :description
      # Curve generator
      t.references :reference,                index: true
      t.decimal    :initial_amount,           precision: 19, scale: 4
      t.integer    :amount_round
      t.decimal    :amplitude_factor,         precision: 19, scale: 4, null: false, default: 1
      t.decimal    :offset_amount,            precision: 19, scale: 4, null: false, default: 0
      t.decimal    :positive_alea_amount,     precision: 19, scale: 4, null: false, default: 0
      t.decimal    :negative_alea_amount,     precision: 19, scale: 4, null: false, default: 0
      t.timestamps
    end

    create_table :scenario_curve_steps do |t|
      t.references :curve,  null: false, index: true
      t.integer    :turn,   null: false
      t.decimal    :amount, precision: 19, scale: 4, null: false
      t.timestamps
    end

    create_table :games do |t|
      t.string     :name,        null: false
      t.datetime   :planned_at
      t.string     :state
      t.string     :turn_nature   # month (later, other could come: week, bimester, trimester, quater, semester)
      t.integer    :turn_duration # in minutes
      t.integer    :turns_count
      t.integer    :map_width
      t.integer    :map_height
      t.references :scenario
      t.text       :description
      t.timestamps
    end

    create_table :game_turns do |t|
      t.references :game,           null: false, index: true
      t.integer    :number,         null: false
      t.integer    :duration,       null: false # in real life
      t.datetime   :started_at
      t.datetime   :stopped_at
      t.timestamps
    end

    create_table :participations do |t|
      t.references :game,           null: false, index: true
      t.references :user,           null: false, index: true
      t.references :participant,    null: false, index: true
      t.timestamps
    end

    create_table :participants do |t|
      t.references :game,           null: false, index: true
      t.string     :name,           null: false
      t.string     :code
      t.attachment :logo
      t.string     :type
      t.integer    :zone_x
      t.integer    :zone_y
      t.integer    :zone_width
      t.integer    :zone_height
      t.references :historic,                    index: true
      t.boolean    :client,         null: false, default: false
      t.boolean    :supplier,       null: false, default: false
      t.boolean    :lender,         null: false, default: false
      t.boolean    :borrower,       null: false, default: false
      t.boolean    :contractor,     null: false, default: false
      t.boolean    :subcontractor,  null: false, default: false
      t.timestamps
    end

    create_table :contracts do |t|
      t.references :originator,     null: false, index: true
      t.references :subcontractor,               index: true
      t.string     :variant
      t.decimal    :amount,   precision: 19, scale: 4, null: false
      t.decimal    :quantity, precision: 19, scale: 4, null: false
      t.integer    :release_turn,  null: false
      t.integer    :delivery_turn, null: false
      t.text       :description
      t.timestamps
    end

    create_table :deals do |t|
      t.references :client,      null: false, index: false
      t.references :supplier,    null: false, index: false
      t.decimal    :amount,      precision: 19, scale: 4
      t.timestamps
    end

    create_table :deal_items do |t|
      t.references :deal,        null: false, index: false
      t.string     :variant
      t.string     :tax
      t.decimal    :quantity,           precision: 19, scale: 4
      t.decimal    :unit_pretax_amount, precision: 19, scale: 4
      t.decimal    :unit_amount,        precision: 19, scale: 4
      t.decimal    :pretax_amount,      precision: 19, scale: 4
      t.decimal    :amount,             precision: 19, scale: 4
      t.timestamps
    end

    create_table :loans do |t|
      t.references :borrower,    null: false, index: false
      t.references :lender,      null: false, index: false
      t.decimal    :amount,      precision: 19, scale: 4
      t.integer    :turns_count, null: false
      t.decimal    :interest_percentage,  precision: 19, scale: 4, null: false
      t.decimal    :insurance_percentage, precision: 19, scale: 4, null: false
      t.timestamps
    end

    create_table :catalog_items do |t|
      t.references :participant,  null: false, index: true
      t.string     :variant,      null: false, index: true
      t.string     :nature
      t.decimal    :quota,                      precision: 19, scale: 4, null: false
      t.decimal    :positive_margin_percentage, precision: 19, scale: 4, null: false, default: 0
      t.decimal    :negative_margin_percentage, precision: 19, scale: 4, null: false, default: 0
      t.timestamps
    end

  end
end
