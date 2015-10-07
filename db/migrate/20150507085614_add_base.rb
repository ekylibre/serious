class AddBase < ActiveRecord::Migration
  def change
    # Start of everything: 01/09/2015

    create_table :scenarios do |t|
      t.string :name,         null: false
      t.string :code,         null: false
      t.string :currency,     null: false
      t.string :turn_nature # month
      t.string :turns_count,  null: false # 12 seems to be minimum
      t.date :started_on,     null: false
      t.attachment :historic
      t.text :description
      t.json :monthly_expenses
      t.timestamps
    end

    create_table :scenario_broadcasts do |t|
      t.references :scenario, null: false, index: true
      t.string :name, null: false
      t.integer :release_turn, null: false
      t.text :content
      t.timestamps
    end

    create_table :scenario_curves do |t|
      t.references :scenario, null: false, index: true
      t.string :nature,      null: false # variant, loan_interest, reference
      t.string :name,        null: false
      t.string :code,        null: false
      t.string :unit_name
      t.string :variant_indicator_name
      t.string :variant_indicator_unit
      t.string :interpolation_method # linear, previous, next
      t.text :description
      # Curve generator
      t.references :reference, index: true
      t.decimal :initial_amount, precision: 19, scale: 4
      t.integer :amount_round
      t.decimal :amplitude_factor,         precision: 19, scale: 4, null: false, default: 1
      t.decimal :offset_amount,            precision: 19, scale: 4, null: false, default: 0
      t.decimal :positive_alea_amount,     precision: 19, scale: 4, null: false, default: 0
      t.decimal :negative_alea_amount,     precision: 19, scale: 4, null: false, default: 0
      t.timestamps
    end

    create_table :scenario_curve_steps do |t|
      t.references :curve, null: false, index: true
      t.integer :turn,   null: false
      t.decimal :amount, precision: 19, scale: 4, null: false
      t.timestamps
    end

    create_table :scenario_issues do |t|
      t.references :scenario, null: false, index: true
      t.string :name,             null: false
      t.string :nature,           null: false
      t.string :variety
      t.integer :trigger_turn
      t.string :coordinates_nature
      t.text :coordinates
      t.decimal :destruction_percentage, precision: 19, scale: 4
      t.integer :minimal_age
      t.integer :maximal_age
      t.string :impacted_indicator_name
      t.string :impacted_indicator_value
      t.text :description
      t.timestamps
    end

    create_table :games do |t|
      t.string :name, null: false
      t.datetime :planned_at
      t.datetime :launched_at
      t.string :state
      t.string :access_token
      t.string :turn_nature # month (later, other could come: week, bimester, trimester, quater, semester)
      t.integer :turn_duration # in minutes
      t.integer :turns_count
      t.integer :map_width
      t.integer :map_height
      t.references :scenario, index: true
      t.text :description
      t.timestamps
    end

    create_table :game_turns do |t|
      t.references :game, null: false, index: true
      t.integer :number,         null: false
      t.integer :duration,       null: false # in real life
      t.boolean :expenses_paid,  null: false, default: false
      t.datetime :started_at
      t.datetime :stopped_at
      t.timestamps
    end

    create_table :participations do |t|
      t.references :game,           null: false, index: true
      t.references :user,           null: false, index: true
      t.string :nature,             null: false, index: true
      t.references :participant,                 index: true
      t.timestamps
    end

    create_table :participants do |t|
      t.references :game,        null: false, index: true
      t.string :nature,          null: false, index: true
      t.string :name,            null: false
      t.string :code,            null: false
      t.attachment :logo
      t.string :tenant
      t.string :access_token
      t.string :application_url
      t.string :stand_number
      t.boolean :present,        null: false, default: false
      t.boolean :closed,         null: false, default: false
      t.boolean :customer,       null: false, default: false
      t.boolean :supplier,       null: false, default: false
      t.boolean :lender,         null: false, default: false
      t.boolean :borrower,       null: false, default: false
      t.boolean :contractor,     null: false, default: false
      t.boolean :subcontractor,  null: false, default: false
      t.boolean :insurer,        null: false, default: false
      t.boolean :insured,        null: false, default: false
      t.integer :zone_x
      t.integer :zone_y
      t.integer :zone_width
      t.integer :zone_height
      t.timestamps
    end

    create_table :participant_ratings do |t|
      t.references :participant, null: false, index: true
      t.references :game, null: false, index: true
      t.timestamp :rated_at, null: false
      t.json :report
      t.timestamps
    end

    create_table :catalog_items do |t|
      t.references :participant, null: false, index: true
      t.string :variant,         null: false, index: true
      t.string :nature,          null: false
      t.string :tax,             null: false
      t.decimal :quota,                      precision: 19, scale: 4, null: false
      t.decimal :positive_margin_percentage, precision: 19, scale: 4, null: false, default: 0
      t.decimal :negative_margin_percentage, precision: 19, scale: 4, null: false, default: 0
      t.timestamps
    end

    create_table :contract_natures do |t|
      t.references :contractor,  null: false, index: true
      t.decimal :amount,         precision: 19, scale: 4, null: false
      t.integer :release_turn,   null: false
      t.string :name,            null: false
      t.string :variant
      t.text :description
      t.integer :contracts_count
      t.integer :contracts_quota
      t.timestamps
    end

    create_table :contracts do |t|
      t.references :contractor,    null: false, index: true
      t.references :subcontractor, null: false, index: true
      t.references :nature,        null: false, index: true
      t.references :game,          null: false, index: true
      t.integer :delivery_turn,    null: false
      t.decimal :quantity, precision: 19, scale: 4, null: false
      t.string :state
      t.timestamps
    end

    create_table :deals do |t|
      t.references :customer,    null: false, index: true
      t.references :supplier,    null: false, index: true
      t.references :game,        null: false, index: true
      t.string :state,           null: false
      t.decimal :pretax_amount,  precision: 19, scale: 4, null: false, default: 0
      t.decimal :amount,         precision: 19, scale: 4, null: false, default: 0
      t.datetime :invoiced_at
      t.timestamps
    end

    create_table :deal_items do |t|
      t.references :deal, null: false, index: true
      t.string :variant,  null: false
      t.string :tax,      null: false
      t.text :product
      t.decimal :unit_pretax_amount, precision: 19, scale: 4, null: false
      t.decimal :unit_amount,        precision: 19, scale: 4, null: false
      t.decimal :quantity,           precision: 19, scale: 4, null: false
      t.decimal :pretax_amount,      precision: 19, scale: 4, null: false
      t.decimal :amount,             precision: 19, scale: 4, null: false
      t.references :catalog_item, index: true
      t.integer :product_id, index: true
      t.timestamps
    end

    create_table :loans do |t|
      t.references :borrower,    null: false, index: true
      t.references :lender,      null: false, index: true
      t.references :game,        null: false, index: true
      t.decimal :amount,         precision: 19, scale: 4, null: false
      t.integer :turns_count,    null: false
      t.decimal :interest_percentage,  precision: 19, scale: 4, null: false
      t.decimal :insurance_percentage, precision: 19, scale: 4, null: false
      t.timestamps
    end

    create_table :insurances do |t|
      t.references :insurer,     null: false, index: true
      t.references :insured,     null: false, index: true
      t.references :game,        null: false, index: true
      t.string :nature,          null: false
      t.decimal :unit_pretax_amount,     precision: 19, scale: 4, null: false
      t.decimal :unit_refundable_amount, precision: 19, scale: 4
      t.decimal :quantity_value,         precision: 19, scale: 4, null: false
      t.string :quantity_unit, null: false
      t.decimal :tax_percentage,         precision: 19, scale: 4, null: false, default: 0
      t.decimal :pretax_amount,          precision: 19, scale: 4, null: false
      t.decimal :amount,                 precision: 19, scale: 4, null: false
      t.decimal :excess_amount,          precision: 19, scale: 4, null: false, default: 0
      t.timestamps
    end

    create_table :insurance_indemnifications do |t|
      t.references :insurance, null: false
      t.decimal :amount,       null: false, precision: 19, scale: 4
      t.date :paid_on,         null: false
      t.timestamps
    end
  end
end
