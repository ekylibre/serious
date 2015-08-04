class AddBase < ActiveRecord::Migration
  def change

    # Start of everything: 01/09/2015

    create_table :historics do |t|
      t.string     :name,         null: false
      t.string     :code,         null: false
      t.string     :currency,     null: false
      t.text       :description
      t.timestamps
    end

    create_table :scenarios do |t|
      t.string     :name,         null: false
      t.string     :code,         null: false
      t.string     :currency,     null: false
      t.string     :turn_nature               # month
      t.string     :turns_count,  null: false # 12 seems to be minimum
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
      t.string     :nature,      null: false # variant, loan_interest, reference
      t.string     :name,        null: false
      t.string     :code,        null: false
      t.string     :unit_name
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

    create_table :scenario_issues do |t|
      t.references    :scenario,         null: false, index: true
      t.string        :name,             null: false
      t.string        :description,      null: false
      t.integer       :turn,             null: false
      t.string        :nature,           null: false
      t.string        :variety,          null: false
      t.integer       :trigger_turn,     null: false
      t.multi_polygon :shape
      t.decimal       :destruction_percentage, precision: 19, scale: 4
      t.integer       :minimal_age
      t.integer       :maximal_age
      t.string        :impact_indicator_name
      t.decimal       :impact_indicator_value, precision: 19, scale: 4
    end

    create_table :insurances do |t|
      t.string      :nature,                  null: false
      t.decimal     :unit_pretax_amount ,     null: false, precision: 19, scale: 4
      t.decimal     :pretax_amount,                        precision: 19, scale: 4
      t.decimal     :unit_refundable_amount,               precision: 19, scale: 4
      t.references  :insurer,                 null: false
      t.references  :insured,                 null: false
      t.decimal     :quantity_value, precision: 19, scale: 4
      t.string      :quantity_unit
      t.decimal     :tax_percentage, precision: 19, scale: 4
      t.decimal     :amount, precision: 19, scale: 4
    end

    create_table :insurance_indemnifications do |t|
      t.references :insurance_id, null:false
      t.decimal    :sum, null: false, precision: 19, scale: 4
      t.date       :paid_on, null: false
    end

    create_table :games do |t|
      t.string     :name,          null: false
      t.datetime   :planned_at
      t.string     :state
      t.string     :turn_nature   # month (later, other could come: week, bimester, trimester, quater, semester)
      t.integer    :turn_duration # in minutes
      t.integer    :turns_count
      t.integer    :map_width
      t.integer    :map_height
      t.references :scenario,                    index: true
      t.references :historic,                    index: true
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
      t.string     :nature,         null: false
      t.references :participant,                 index: true
      t.timestamps
    end

    create_table :participants do |t|
      t.references :game,           null: false, index: true
      t.string     :name,           null: false
      t.string     :code,           null: false
      t.attachment :logo
      t.string     :type
      t.string     :application_url
      t.integer    :zone_x
      t.integer    :zone_y
      t.integer    :zone_width
      t.integer    :zone_height
      t.boolean    :customer,       null: false, default: false
      t.boolean    :supplier,       null: false, default: false
      t.boolean    :lender,         null: false, default: false
      t.boolean    :borrower,       null: false, default: false
      t.boolean    :contractor,     null: false, default: false
      t.boolean    :subcontractor,  null: false, default: false
      t.boolean    :insurer,        null: true, default: false
      t.boolean    :insured,        null: true, default: false
      t.timestamps
    end

    create_table :contract_natures do |t|
      t.references :contractor,    null: false, index: true
      t.string     :name
      t.string     :variant
      t.decimal    :amount,        precision: 19, scale: 4, null: false
      t.integer    :release_turn,  null: false
      t.text       :description
      t.integer    :contracts_count
      t.integer    :contracts_quota
    end

    create_table :contracts do |t|
      t.references :contractor,     null: false, index: true
      t.references :subcontractor,               index: true
      t.references :nature,         null: false, index: true
      t.integer    :delivery_turn,  null: false
      t.decimal    :quantity, precision: 19, scale: 4, null: false
      t.string     :state
      t.timestamps
    end

    create_table :deals do |t|
      t.references :customer,    null: false, index: true
      t.references :supplier,    null: false, index: true
      t.decimal    :amount,      precision: 19, scale: 4
      t.timestamps
    end

    create_table :deal_items do |t|
      t.references :deal,        null: false, index: true
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
      t.references :borrower,    null: false, index: true
      t.references :lender,      null: false, index: true
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
