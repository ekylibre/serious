# coding: utf-8
namespace :serious do

  task :scenario => :environment do
    here = Pathname.new(__FILE__).dirname

    slength = ENV["TURNS"] || 60
    scenario = {}
    scenario[:name] = ENV["SCENARIO"] || FFaker::LoremFR.words.join(" ")
    scenario[:code] = ENV["CODE"] || scenario[:name].parameterize.split("-").map{|w| w[0..0].upcase}.join
    scenario[:description] = FFaker::LoremFR.paragraph(10)
    scenario[:turn_nature] = "month"
    scenario[:turns_count] = slength
    scenario[:currency] = "EUR"

    broadcasts = []
    turn = rand(3) + 1
    while turn < slength
      broadcasts << {
        name: FFaker::LoremFR.sentence,
        content: FFaker::LoremFR.paragraph(5),
        release_turn: turn
      }
      turn += rand(3) + 1
    end
    scenario[:broadcasts] = broadcasts

    curves = {}
    # references
    references = YAML.load_file(here.join("references.yml")).deep_symbolize_keys
    references.each do |id, ref|
      variation = 0
      turn = 1
      amount = ref[:initial_amount]
      variation_amplitude = ref[:variation_amplitude] || ref[:initial_amount] * 0.03
      steps = []
      while turn < slength
        steps << {turn: turn, amount: amount.round(ref[:round] || 2)}
        variation += variation_amplitude * ((ref[:positive_variation] || 1) * rand - (ref[:negative_variation] || 1) * rand)
        amount += variation
        turn += rand(slength * 0.12).to_i + 1
      end
      curves[id] = {
        name: ref[:name],
        description: ref[:description],
        nature: "reference",
        unit_name: ref[:unit_name],
        initial_amount: ref[:initial_amount],
        steps: steps
      }
    end
    # variants

    # loan_interest

    scenario[:curves] = curves

    path = Rails.root.join("db", "scenarios", scenario[:name].parameterize + ".yml")
    FileUtils.mkdir_p(path.dirname)
    File.write(path, scenario.deep_stringify_keys.to_yaml)
    puts "Scenario '#{scenario[:name]}' (#{scenario[:code]}) was written in #{path}".yellow
  end


  desc "Generates a game with users"
  task :game => :environment do
    here = Pathname.new(__FILE__).dirname

    users = YAML.load_file(Rails.root.join("db", "users.yml")).collect{|u| u["email"]}

    game = {}
    game[:name] = ENV["GAME"] || FFaker::LoremFR.words.join(" ")
    game[:scenario] = ENV["SCENARIO"] if ENV["SCENARIO"]

    participations = []

    farms = {}
    15.times do |index|
      code = "F#{(index + 1).to_s.rjust(2, '0')}"
      farms[code] = {name: "Ferme #{FFaker::NameFR.last_name}#{index}", historic: "SL47"}
      4.times do
        user = users.delete(users.sample)
        participations << {participant: code, user: user}
      end
    end
    game[:farms] = farms

    actors = {}
    ["Crédit Agricole", "Groupama", "Unicoque", "Terre du Sud", "Razol", "CER", "@com", "MSA"].each_with_index do |name, index|
      code = "A#{(index + 1).to_s.rjust(2, '0')}"
      actors[code] = {name: name}
      rand(3).times do
        user = users.delete(users.sample)
        participations << {participant: code, user: user}
      end
    end
    game[:actors] = actors

    game[:participations] = participations

    path = Rails.root.join("db", "games", game[:name].parameterize + ".yml")
    FileUtils.mkdir_p(path.dirname)
    File.write(path, game.deep_stringify_keys.to_yaml)
    puts "Game '#{game[:name]}' was written in #{path}".yellow
  end


  desc "Generates a set of users"
  task :users => :environment do
    here = Pathname.new(__FILE__).dirname

    users = []
    200.times do |index|
      first_name, last_name = FFaker::NameFR.first_name, FFaker::NameFR.last_name.mb_chars.upcase.to_s
      email = "#{first_name.parameterize}.#{last_name.parameterize}@#{FFaker::Internet.domain_name}"
      users << {first_name: first_name, last_name: last_name, email: email}.deep_stringify_keys
    end

    path = Rails.root.join("db", "users.yml")
    FileUtils.mkdir_p(path.dirname)
    File.write(path, users.to_yaml)
    puts "Sample users were written in #{path}".yellow
  end


end
