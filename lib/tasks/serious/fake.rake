# coding: utf-8
require 'serious'

namespace :serious do
  namespace :fake do
    VARIANTS = %w(115g_jam 230g_jam 25kg_bag_animal_food 25kg_bag_hen_food 25kg_bag_pig_food 25kg_bag_rabbit_food accommodation_taxe accommodation_travel acetal actilact additive air_compressor all_inclusive_corn_sower animal_building animal_division animal_fence animal_food_division animal_housing_cleaner animal_housing_service animal_medicine_tank animal_waste_building_division animals_making_service annual_fallow_crop anti_slug apple_crop arezzo_wheat_crop ascott_wheat_crop ascott_wheat_seed_25 asparagus_crop associate_social_contribution baler bank_service barley_grain battery bean_crop bee_band bee_band_pollinate_service beef_dried_sausage beef_meat beef_sausage beet_crop big_sticker blackcurrant_crop blackcurrant_seedling bolt bordelaise_100cl_bottle bordelaise_75cl_bottle bos_vial bottle_75cl_wine brassicaceae_fungicide building building_division building_insurance building_material building_material_in_own_outstanding_installation bulk_ammo_phosphorus_sulfur_20_23_0 bulk_ammonitrate_27 bulk_ammonitrate_33 bulk_animal_food bulk_chlorure_60_gr_vr bulk_diammo_phosphorus_21_53_0 bulk_fertilizer_0_24_05 bulk_fertilizer_15_15_15 bulk_hay bulk_kg_animal_food bulk_urea_46 bulk_wheat_straw bumblebee_band burdock_crop butler_hazelnut cabbage_crop calcium_carbonate_25kg calf cap_subsidies caphorn_wheat_crop caphorn_wheat_seed_25 capra_manure car car_moving_travel card carriage carrot_crop cattle_compost cattle_herd cattle_liquid_slurry cattle_manure cattle_slurry cereals_feed_bag_25 chainsaw chandler_walnut chemical_fertilizer_division cherry_laurel_crop chick_hen_band chicken_egg chicken_meat chicory_crop common_consumable common_package complete_herbicide computer_display computer_item computer_mouse concrete_tank congress consumer_goods_office_item coop:adexar_5l coop:altacid_vrac coop:altiplus_gr_vrac coop:ammonitre_27_vr coop:ammonitre_33_5_bb coop:ammonitre_33_5_vr coop:atlantis_wg_3_kg coop:atlantis_wg_600_gr coop:aviator_xpro_5l coop:avoine_d_hiver_n_evora_cel_net_s25kg coop:avoine_d_hiver_n_une_de_mai_en_s20kg coop:avoine_d_hiver_une_de_mai_red_25kg coop:axial_pratic_5_l coop:balmora_5_l coop:bd_s_miradoux_r1_cel_gold_net_25kg coop:bd_s_miradoux_r1_gau_red_25kg coop:bd_s_r1_miradoux_gau_vibrance_d500mg coop:bd_s_tablur_r1_cel_gold_net_25kg coop:bd_s_tablur_r1_gau_red_25kg coop:bell_star_5_l coop:boa_3_l coop:bofix_20_l coop:bofix_5_l coop:bromotril_225_5_l coop:bth_s_arezzo_r1_gau_red_lat_s25kg coop:bth_s_ascott_r1_gau_red_s25kg coop:bth_s_caphorn_r1_cel_gold_net_25kg coop:bth_s_caphorn_r1_gau_red_25kg coop:bth_s_caphorn_r1_gau_red_lat_s25kg coop:bth_s_euclide_r1_cel_gold_net_25kg coop:bth_s_euclide_r1_gau_red_25kg coop:bth_s_premio_r1_gau_red_25kg coop:bth_s_rubisko_r1_gau_red_s25kg coop:buggy_plus_100_l coop:callisto_5_l coop:ceando_5_l coop:chardex_5_l coop:chlorure_60_gr_vr coop:da_lazuly_10kg coop:eca_excel_pack_protor_b_vrac coop:eca_pack_tonus_b_vrac coop:elite_4_sc_5_l coop:esc_s_arturio_r1_gau_red_25kg coop:esc_s_etincel_r1_gau_red_s25kg coop:extralugec_techn_o_15kg coop:fandango_s_5_l coop:fertiactyl_starter coop:ficelle_filogamm_350_bob_5kg coop:film_ensil_ensigamm_10m coop:film_ensil_ensigamm_14m coop:film_ensil_ensigamm_8m coop:fongistop_fl_5_l coop:humistart_bb coop:kalao_d_5_l coop:luzerne_comete_s10k coop:ma_aallexia_50mg coop:ma_bergxxon_50mg coop:ma_bergxxon_duo_50mg coop:ma_bergxxon_duo_sonido_d50mg coop:ma_boomer_50mg coop:ma_dkc_3912_50mgr coop:ma_lg30533_cruiser_50mg coop:ma_lg3490_50mg coop:ma_lg3490_cruiser_50mg coop:ma_lg3490_sonido_d50mg coop:ma_lg3530_cruiser_50mg coop:ma_shannon_50mg coop:madit_dispersion_20_l coop:matin_el_10_l coop:mercantor_gold_5_l coop:mesurol_pro_20_kg coop:mesurol_pro_5_kg coop:metarex_ino_20_kg coop:metarex_rg_tds_20kg coop:mextra_5_l coop:microthiol_sp_disp coop:mix_in_5_l coop:moha_10kg coop:moha_25kg coop:nikeyl_5_l coop:op_s_traveler_r1_cel_orge_net_s25kg coop:pois_s_kayanne_print_wakil_xl_r1_s25kg coop:presite_sx_300_gr coop:prosaro_5_l coop:ray_g_hyb_bahial_10kg coop:sel_mer_essore_la_baleine_sac_25kg coop:sorgho_ensilage_bmr_333_220mg coop:super_45_gr_vr coop:super_46_gr_vr coop:technomousse_500_ml coop:to_ol_ferti_150mg coop:trefle_alexandrie_s10k coop:trefle_v_segur_s10k coop:uree_gr_vrac coop:vesce_velue_savane_hiver_10k corabel_hazelnut corker corn_crop corn_grain corn_grain_crop corn_seed_25 corn_seed_50tg corn_seed_crop corn_silage corn_silage_crop cover_implanter cow_milk creation_society_study crop_residue cultivable_zone daily_project_management daily_software_engineering daily_training_course dairy_equipment_cleaner diesel discount_and_reduction domain_name_subscription drying_making_service duck_band duck_herd duck_manure duck_slurry eco_participation electricity employee ennis_hazelnut equipment equipment_building_division equipment_insurance equipment_repair_service escalope_veal_meat escourgeon_barley_crop etincel_winter_barley_crop euclide_wheat_crop euclide_wheat_seed_25 ewe_milk fallow_crop farm_teaching_service fee female_adult_cattle_herd female_adult_cow female_adult_goat female_adult_goat_herd female_adult_horse female_adult_pig female_adult_pony female_adult_rabbit female_adult_sheep female_adult_sheep_herd female_hen_band female_pig_band female_young_cattle_herd female_young_cow female_young_goat female_young_pig_band female_young_sheep fercoril_corabel_hazelnut feriale_hazelnut fernor_walnut fertile_coutard_hazelnut fertile_hazelnut fiberglass_tank fig_crop fig_seedling fiscal_fine flax_crop food_equipment_division food_show food_tank forager forklift forwarding_agent_fees_expense franquette_walnut freelance_sofware_development freezer_tank frozen_fruit fruit_derivative_good fuel_tank fungicide furniture garlic_crop gas gasoline generic_animal_medicine goat_herd goat_milk gooseberry_crop gooseberry_seedling grain_crusher grain_tank granulated_insecticide_12 grape_reaper grape_trailer grass grass_seed_25 grass_silage green_compost grinder guineafowl_manure hand_drawn hanging_scroll hard_wheat_crop hard_wheat_grain hard_wheat_seed_25 harvesting_making_service hay_big_rectangular_bales hay_rake hay_round_bales hay_small_rectangular_bales hazel_crop hazel_reaper hazel_seedling hazelnut hedge_cutter helianthus_herbicide hen_compost hen_guano hen_herd hen_manure hen_slurry herbicide hoe horse_compost horse_herd horse_manure horsebean_crop hourly_project_management hourly_software_engineering hourly_training_course hourly_user_support howard_walnut hydraulic_oil ichn_subsidies implanter infirmity_and_death_insurance ink_cartridge insecticide inseminator insurance internet_line_subscription intership ip_address_subscription irrigation_water jemstegaard_hazelnut lactic_acid_25kg lamb lamb_meat lamb_sausage land_parcel land_parcel_cluster land_parcel_locative_charge lara_walnut lavender_crop leasing leek_crop legal_registration lentil_crop lettuce_crop lewis_hazelnut liquid_10_25_d1.4 liquid_10_34_d1.4 liquid_nitrogen_30_d1.3 little_office_equipment little_office_good livestock_cleanliness_product loan_interest lucerne_bulk_hay lucerne_crop lucerne_seed lupin_crop maintenance male_adult_cattle_herd male_adult_cow male_adult_goat male_adult_goat_herd male_adult_horse male_adult_pig male_adult_pony male_adult_rabbit male_adult_sheep male_hen_band male_pig_band male_young_cattle_herd male_young_cow male_young_goat male_young_pig_band male_young_sheep malic_acid_25kg manager manual_implanter manure_division market_gardening_crop meadow_grass meal_travel merlot_noir_so4_vine_seedling merveille_hazelnut milk_tank milked_lamb_meat milked_pork_meat milking_division minced_beef_meat minced_ox_meat mineral_cleaner mineral_feed_block_25 miradoux_hard_wheat_crop miradoux_hard_wheat_seed_25 mixed_chemical_fertilizer mixed_liquid_fertilizer mixture_seed mixture_vetch_oat_pea_crop molluscicide monthly_enterprise_support motor_oil moving_travel mower mud muskmelon_crop myrobalan_plum_crop natural_cork natural_water negret_hazelnut nibble_lamb_meat nomacorc_cork oenological_yeast_sc_500g office_building office_building_division oilrape_grain other_herbicide ovis_compost ovis_manure ox_meat oyster_band packed_beef_meat packed_ox_meat packed_veal_meat pallet pauetet_hazelnut pea_crop pea_grain pea_seed peach_crop peach_seedling peanut peanut_crop pear_crop pear_seedling permanent_meadow_crop phone_line_subscription pig_compost pig_herd pig_manure pig_slurry piglet_band piglet_meat plant_medicine_tank plastic_cover_500m plow plum plum_crop plum_reaper plum_seedling poaceae_fungicide poaceae_herbicide polyester_tank pony_herd popcorn_grain pork_dried_sausage pork_sausage portable_computer portable_hard_disk postal_charges postal_stamp potassium_bicarbonate_25kg potassium_ferrocyanide_25kg potato_crop poultry_sausage preparation_division printer product_warranty project_study pruning_platform quince_crop quinoa_crop rabbit_herd rabbit_manure rape_crop rape_seed raspberry_crop raspberry_seedling reaper rent representation_suit responsibility_insurance riflexine roast_veal_meat roll rollup ronde_de_piemont_hazelnut rose_crop rose_seedling rubisko_wheat_crop running_water rye_crop saffron_crop saffron_pollen saffron_seedling salary_social_contribution salmon_band screed_building seed seedling segorbe_hazelnut server_certificate_subscription server_rental settlement sheep_herd shoulder_veal_meat silage_distributor silage_division small_equipment small_sticker so2_liquid_a8 so2_liquid_p10 so2_solid_2g so2_solid_5g so4_vine_seedling sorghum_crop sorghum_seed_25 sower soy_crop spelt_seed_25 spelt_wheat_crop sprayer spread_renting spreader spreader_trailer spring_barley_crop spring_barley_seed_25 spring_oat_crop stainless_steel_tank strawberry_crop strawberry_seedling subscription_professional_society subsoil_plow sugar_vinasse sunflower_crop sunflower_grain sunflower_seed_150tg superficial_plow tablur_hard_wheat_crop tablur_hard_wheat_seed_25 tangerine_crop taxe technician temporary_meadow_crop thicket_crop tobacco_crop tonda_giffoni_hazelnut tractor trailer triticale_crop truck urban_compost various_loan_interest veal_meat vine_grape_berry vine_grape_crop vine_grape_juice vine_grape_must vine_residu walnut walnut_crop water_spreader wheat_crop wheat_grain wheat_seed_25 wheat_straw_big_rectangular_bales wheat_straw_round_bales wheat_straw_small_rectangular_bales white_sugar_25kg wine wine_press wine_storage_division wine_vinasse winter_barley_crop winter_barley_seed_25 winter_oat_crop wire_150m_roll wire_50m_roll wood_stake_200 wood_stake_250 young_pig_band young_rabbit zea_herbicide).delete_if { |x| x =~ /(\:|\.|\d)/ or x.split('_').size > 2 or !x.delete('_').to_i(36).modulo(3).zero? }

    desc 'Generate a scenario'
    task scenario: :environment do
      here = Pathname.new(__FILE__).dirname

      lines = File.readlines(here.join('text.txt')).map(&:strip).delete_if { |l| l =~ /^\s*#/ }

      slength = (ENV['TURNS'] || 60).to_i
      scenario = {}
      scenario[:code] = ENV['SCENARIO'] || FFaker::LoremFR.words.join(' ').parameterize
      scenario[:name] = ENV['SCENARIO_NAME'] || scenario[:code].humanize
      scenario[:description] = lines.shift(10).join(' ')
      scenario[:turn_nature] = 'month'
      scenario[:turns_count] = slength
      scenario[:currency] = 'EUR'

      broadcasts = []
      turn = 1
      while turn < slength
        (2 + turn.modulo(3)).times do
          broadcasts << {
            name: lines.shift,
            content: lines.shift(5).join(' '),
            release_turn: turn
          }
        end
        turn += 1
      end
      scenario[:broadcasts] = broadcasts

      curves = {}
      # references
      references = YAML.load_file(here.join('references.yml')).deep_symbolize_keys
      references.each do |id, ref|
        variation = 0
        turn = 1
        amount = ref[:initial_amount]
        variation_amplitude = ref[:variation_amplitude] || ref[:initial_amount] * 0.03
        steps = []
        while turn < slength
          steps << { turn: turn, amount: amount.round(ref[:round] || 2) }
          variation += variation_amplitude * ((ref[:positive_variation] || 1) * rand - (ref[:negative_variation] || 1) * rand)
          amount += variation
          turn += rand(slength * 0.12).to_i + 1
        end
        curves[id] = {
          name: ref[:name],
          description: ref[:description],
          nature: 'reference',
          unit_name: ref[:unit_name],
          initial_amount: ref[:initial_amount],
          steps: steps
        }
      end
      references_keys = references.keys.map(&:to_s)
      # variants
      VARIANTS.each do |v|
        value = v.to_s.to_i(36)
        curves[v] = {
          name: v.humanize,
          nature: 'variant',
          unit_name: 'unit',
          reference: references_keys[value.modulo(references_keys.size)],
          positive_alea_amount: (value.modulo(23) * 1.72).round(2),
          negative_alea_amount: (value.modulo(47) * 1.13).round(2),
          amplitude_factor: (value.modulo(7) * 0.53).round(2),
          offset_amount: (value.modulo(61) * 9.85 - 300).round(2),
          amount_round: (value / 5).modulo(3)
        }
      end

      # loan_interest

      scenario[:curves] = curves

      path = Rails.root.join('db', 'scenarios', scenario[:name].parameterize + '.yml')
      FileUtils.mkdir_p(path.dirname)
      File.write(path, scenario.deep_stringify_keys.to_yaml)
      puts "Scenario '#{scenario[:name]}' (#{scenario[:code]}) was written in #{path}".yellow
    end

    desc 'Generates a game with users'
    task game: :environment do
      here = Pathname.new(__FILE__).dirname

      users_hash = YAML.load_file(Rails.root.join('db', 'users.yml')).inject({}) do |hash, user|
        hash[user['email']] = user.symbolize_keys
        hash
      end
      users = users_hash.keys

      game = {}
      game[:code] = ENV['GAME'] || FFaker::LoremFR.words.join(' ').parameterize
      game[:name] = ENV['GAME_NAME'] || game[:code].humanize
      game[:scenario] = ENV['SCENARIO'] if ENV['SCENARIO']
      participations = []

      participations << { user: 'admin@ekylibre.org', nature: :organizer }
      2.times do
        user = users.shift
        participations << { user: user, nature: :organizer }
      end

      farms = {}
      2.times do |index|
        name = users_hash[participations.last[:user]][:last_name].humanize
        root_name = name
        i = 1
        while farms.values.detect { |f| f[:name] == name }
          i += 1
          name = root_name + " (#{i})"
        end
        code = name.parameterize
        value = I18n.transliterate(name.mb_chars.downcase).to_i(36)
        farms[code] = { name: name, stand_number: "SF#{(index + 1).to_s.rjust(2, '0')}", present: (value.modulo(20) > 1), application_url: "http://#{code}.serious.lan:8080" }
        participations << { participant: code, user: 'admin@ekylibre.org', nature: :player }
        participations << { participant: code, user: 'player@ekylibre.org', nature: :player }
        4.times do
          user = users.shift
          participations << { participant: code, user: user, nature: :player }
        end
      end
      game[:farms] = farms

      actors = {}
      ['Crédit Agricole', 'Groupama', 'Unicoque', 'Terre du Sud', 'Razol', 'CER', 'Acom', 'MSA'].each_with_index do |name, index|
        value = I18n.transliterate(name.mb_chars.downcase).to_i(36)
        code = name.parameterize
        supplier = (value.modulo(10) > 3)
        customer = (value.modulo(25) > 15)
        actors[code] = { name: name, stand_number: "SA#{(index + 1).to_s.rjust(2, '0')}", present: (value.modulo(30) > 6), insurer: (value.modulo(21) > 9), contractor: (value.modulo(21) > 6), supplier: supplier, customer: customer, lender: !(supplier or customer) }
        items = []
        15.times do |index|
          items << { variant: VARIANTS[(index * value).modulo(VARIANTS.size)], tax: Serious::TAXES.keys.first, quota: 1 + value.modulo(7) }
        end
        actors[code][:catalog_items] = items
        participations << { participant: code, user: 'admin@ekylibre.org', nature: :player }
        participations << { participant: code, user: 'player@ekylibre.org', nature: :player }
        (1 + value.modulo(3)).times do
          participations << { participant: code, user: users.shift, nature: :player }
        end
      end
      game[:actors] = actors

      game[:participations] = participations

      path = Rails.root.join('db', 'games', game[:code].parameterize + '.yml')
      FileUtils.mkdir_p(path.dirname)
      File.write(path, game.deep_stringify_keys.to_yaml)
      puts "Game '#{game[:name]}' was written in #{path}".yellow
    end

    desc 'Generates a set of users'
    task users: :environment do
      here = Pathname.new(__FILE__).dirname

      users = []
      200.times do |_index|
        first_name = FFaker::NameFR.first_name
        last_name = FFaker::NameFR.last_name.mb_chars.upcase.to_s
        email = "#{first_name.parameterize}.#{last_name.parameterize}@#{FFaker::Internet.domain_name}"
        users << { first_name: first_name, last_name: last_name, email: email, role: (rand < 0.9 ? :player : rand < 0.7 ? :organizer : :administrator).to_s }.deep_stringify_keys
      end

      path = Rails.root.join('db', 'users.yml')
      FileUtils.mkdir_p(path.dirname)
      File.write(path, users.to_yaml)
      puts "Sample users were written in #{path}".yellow
    end
  end

  desc 'Generate default fake data set'
  task :fake do
    ENV['SCENARIO'] ||= 'random'
    ENV['GAME'] ||= 'test'
    ENV['GAME_NAME'] ||= 'Development game'
    ENV['TURNS'] ||= '12'
    Rake::Task['serious:fake:scenario'].invoke
    Rake::Task['serious:fake:game'].invoke
  end
end
