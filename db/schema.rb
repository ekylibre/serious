# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150507085614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "catalog_items", force: :cascade do |t|
    t.integer  "participant_id",                                                    null: false
    t.string   "variant",                                                           null: false
    t.string   "nature",                                                            null: false
    t.string   "tax",                                                               null: false
    t.decimal  "quota",                      precision: 19, scale: 4,               null: false
    t.decimal  "positive_margin_percentage", precision: 19, scale: 4, default: 0.0, null: false
    t.decimal  "negative_margin_percentage", precision: 19, scale: 4, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "catalog_items", ["participant_id"], name: "index_catalog_items_on_participant_id", using: :btree
  add_index "catalog_items", ["variant"], name: "index_catalog_items_on_variant", using: :btree

  create_table "contract_natures", force: :cascade do |t|
    t.integer  "contractor_id",                            null: false
    t.decimal  "amount",          precision: 19, scale: 4, null: false
    t.integer  "release_turn",                             null: false
    t.string   "name",                                     null: false
    t.string   "variant"
    t.text     "description"
    t.integer  "contracts_count"
    t.integer  "contracts_quota"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contract_natures", ["contractor_id"], name: "index_contract_natures_on_contractor_id", using: :btree

  create_table "contracts", force: :cascade do |t|
    t.integer  "contractor_id",                             null: false
    t.integer  "subcontractor_id",                          null: false
    t.integer  "nature_id",                                 null: false
    t.integer  "game_id",                                   null: false
    t.integer  "delivery_turn",                             null: false
    t.decimal  "quantity",         precision: 19, scale: 4, null: false
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contracts", ["contractor_id"], name: "index_contracts_on_contractor_id", using: :btree
  add_index "contracts", ["game_id"], name: "index_contracts_on_game_id", using: :btree
  add_index "contracts", ["nature_id"], name: "index_contracts_on_nature_id", using: :btree
  add_index "contracts", ["subcontractor_id"], name: "index_contracts_on_subcontractor_id", using: :btree

  create_table "deal_items", force: :cascade do |t|
    t.integer  "deal_id",                                     null: false
    t.string   "variant",                                     null: false
    t.string   "tax",                                         null: false
    t.text     "product"
    t.decimal  "unit_pretax_amount", precision: 19, scale: 4, null: false
    t.decimal  "unit_amount",        precision: 19, scale: 4, null: false
    t.decimal  "quantity",           precision: 19, scale: 4, null: false
    t.decimal  "pretax_amount",      precision: 19, scale: 4, null: false
    t.decimal  "amount",             precision: 19, scale: 4, null: false
    t.integer  "catalog_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_items", ["catalog_item_id"], name: "index_deal_items_on_catalog_item_id", using: :btree
  add_index "deal_items", ["deal_id"], name: "index_deal_items_on_deal_id", using: :btree

  create_table "deals", force: :cascade do |t|
    t.integer  "customer_id",                                          null: false
    t.integer  "supplier_id",                                          null: false
    t.integer  "game_id",                                              null: false
    t.string   "state",                                                null: false
    t.decimal  "pretax_amount", precision: 19, scale: 4, default: 0.0, null: false
    t.decimal  "amount",        precision: 19, scale: 4, default: 0.0, null: false
    t.datetime "invoiced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deals", ["customer_id"], name: "index_deals_on_customer_id", using: :btree
  add_index "deals", ["game_id"], name: "index_deals_on_game_id", using: :btree
  add_index "deals", ["supplier_id"], name: "index_deals_on_supplier_id", using: :btree

  create_table "game_turns", force: :cascade do |t|
    t.integer  "game_id",    null: false
    t.integer  "number",     null: false
    t.integer  "duration",   null: false
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_turns", ["game_id"], name: "index_game_turns_on_game_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "name",          null: false
    t.datetime "planned_at"
    t.datetime "launched_at"
    t.string   "state"
    t.string   "access_token"
    t.string   "turn_nature"
    t.integer  "turn_duration"
    t.integer  "turns_count"
    t.integer  "map_width"
    t.integer  "map_height"
    t.integer  "scenario_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["scenario_id"], name: "index_games_on_scenario_id", using: :btree

  create_table "insurance_indemnifications", force: :cascade do |t|
    t.integer  "insurance_id",                          null: false
    t.decimal  "amount",       precision: 19, scale: 4, null: false
    t.date     "paid_on",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insurances", force: :cascade do |t|
    t.integer  "insurer_id",                                                    null: false
    t.integer  "insured_id",                                                    null: false
    t.integer  "game_id",                                                       null: false
    t.string   "nature",                                                        null: false
    t.decimal  "unit_pretax_amount",     precision: 19, scale: 4,               null: false
    t.decimal  "unit_refundable_amount", precision: 19, scale: 4
    t.decimal  "quantity_value",         precision: 19, scale: 4,               null: false
    t.string   "quantity_unit",                                                 null: false
    t.decimal  "tax_percentage",         precision: 19, scale: 4, default: 0.0, null: false
    t.decimal  "pretax_amount",          precision: 19, scale: 4,               null: false
    t.decimal  "amount",                 precision: 19, scale: 4,               null: false
    t.decimal  "excess_amount",          precision: 19, scale: 4, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "insurances", ["game_id"], name: "index_insurances_on_game_id", using: :btree
  add_index "insurances", ["insured_id"], name: "index_insurances_on_insured_id", using: :btree
  add_index "insurances", ["insurer_id"], name: "index_insurances_on_insurer_id", using: :btree

  create_table "loans", force: :cascade do |t|
    t.integer  "borrower_id",                                   null: false
    t.integer  "lender_id",                                     null: false
    t.integer  "game_id",                                       null: false
    t.decimal  "amount",               precision: 19, scale: 4, null: false
    t.integer  "turns_count",                                   null: false
    t.decimal  "interest_percentage",  precision: 19, scale: 4, null: false
    t.decimal  "insurance_percentage", precision: 19, scale: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loans", ["borrower_id"], name: "index_loans_on_borrower_id", using: :btree
  add_index "loans", ["game_id"], name: "index_loans_on_game_id", using: :btree
  add_index "loans", ["lender_id"], name: "index_loans_on_lender_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer  "game_id",                           null: false
    t.string   "nature",                            null: false
    t.string   "name",                              null: false
    t.string   "code",                              null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "tenant"
    t.string   "access_token"
    t.string   "application_url"
    t.string   "stand_number"
    t.boolean  "present",           default: false, null: false
    t.boolean  "customer",          default: false, null: false
    t.boolean  "supplier",          default: false, null: false
    t.boolean  "lender",            default: false, null: false
    t.boolean  "borrower",          default: false, null: false
    t.boolean  "contractor",        default: false, null: false
    t.boolean  "subcontractor",     default: false, null: false
    t.boolean  "insurer",           default: false, null: false
    t.boolean  "insured",           default: false, null: false
    t.integer  "zone_x"
    t.integer  "zone_y"
    t.integer  "zone_width"
    t.integer  "zone_height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["game_id"], name: "index_participants_on_game_id", using: :btree
  add_index "participants", ["nature"], name: "index_participants_on_nature", using: :btree

  create_table "participations", force: :cascade do |t|
    t.integer  "game_id",        null: false
    t.integer  "user_id",        null: false
    t.string   "nature",         null: false
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["game_id"], name: "index_participations_on_game_id", using: :btree
  add_index "participations", ["nature"], name: "index_participations_on_nature", using: :btree
  add_index "participations", ["participant_id"], name: "index_participations_on_participant_id", using: :btree
  add_index "participations", ["user_id"], name: "index_participations_on_user_id", using: :btree

  create_table "scenario_broadcasts", force: :cascade do |t|
    t.integer  "scenario_id",  null: false
    t.string   "name",         null: false
    t.integer  "release_turn", null: false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scenario_broadcasts", ["scenario_id"], name: "index_scenario_broadcasts_on_scenario_id", using: :btree

  create_table "scenario_curve_steps", force: :cascade do |t|
    t.integer  "curve_id",                            null: false
    t.integer  "turn",                                null: false
    t.decimal  "amount",     precision: 19, scale: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scenario_curve_steps", ["curve_id"], name: "index_scenario_curve_steps_on_curve_id", using: :btree

  create_table "scenario_curves", force: :cascade do |t|
    t.integer  "scenario_id",                                                   null: false
    t.string   "nature",                                                        null: false
    t.string   "name",                                                          null: false
    t.string   "code",                                                          null: false
    t.string   "unit_name"
    t.string   "variant_indicator_name"
    t.string   "variant_indicator_unit"
    t.string   "interpolation_method"
    t.text     "description"
    t.integer  "reference_id"
    t.decimal  "initial_amount",         precision: 19, scale: 4
    t.integer  "amount_round"
    t.decimal  "amplitude_factor",       precision: 19, scale: 4, default: 1.0, null: false
    t.decimal  "offset_amount",          precision: 19, scale: 4, default: 0.0, null: false
    t.decimal  "positive_alea_amount",   precision: 19, scale: 4, default: 0.0, null: false
    t.decimal  "negative_alea_amount",   precision: 19, scale: 4, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scenario_curves", ["reference_id"], name: "index_scenario_curves_on_reference_id", using: :btree
  add_index "scenario_curves", ["scenario_id"], name: "index_scenario_curves_on_scenario_id", using: :btree

  create_table "scenario_issues", force: :cascade do |t|
    t.integer  "scenario_id",                                                                                  null: false
    t.string   "name",                                                                                         null: false
    t.string   "description",                                                                                  null: false
    t.string   "nature",                                                                                       null: false
    t.string   "variety",                                                                                      null: false
    t.integer  "trigger_turn",                                                                                 null: false
    t.geometry "shape",                    limit: {:srid=>0, :type=>"multi_polygon"}
    t.decimal  "destruction_percentage",                                              precision: 19, scale: 4
    t.integer  "minimal_age"
    t.integer  "maximal_age"
    t.string   "impacted_indicator_name"
    t.string   "impacted_indicator_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scenario_issues", ["scenario_id"], name: "index_scenario_issues_on_scenario_id", using: :btree

  create_table "scenarios", force: :cascade do |t|
    t.string   "name",                  null: false
    t.string   "code",                  null: false
    t.string   "currency",              null: false
    t.string   "turn_nature"
    t.string   "turns_count",           null: false
    t.date     "started_on",            null: false
    t.string   "historic_file_name"
    t.string   "historic_content_type"
    t.integer  "historic_file_size"
    t.datetime "historic_updated_at"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role",                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
