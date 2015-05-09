# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

slength = 60

scenario = Scenario.create!(name: "Fin du monde", description: "Dans un futur proche, les grandes nations sont entrées en guerre pour le pétrole ; exaspérées par la situation de crise, les populations se sont révoltées, les nations essaient de maintenir un semblant d'ordre tandis que des bandes de délinquants sillonnent les routes...", turns_count: slength)

scenario.broadcasts.create!(name: "Ravage dans les rizières chinoises suite à une attaque de champignons", content: "L'agriculture chinoise connait sa plus grande crise depuis 1923, suite à l'invasion d'un champignon dans près de 73% des rizières du pays. Cette invasion sans commune mesure, a déjà détruit plus de 50% de la production des exploitations concernées. À ce jour, les contre-mesures mises en place se sont avérées inefficaces.", release_turn: 5)

scenario.broadcasts.create!(name: "Mouton : enfin la laine fraîche", content: "Les ligues de protection ont gagné un combat de longue haleine. Il est maintenant obligatoire de shampouiner les moutons avant de les passer à la tondeuse comme n'importe quel coiffeur le ferait.", release_turn: 2)


amount = 2712
curve = scenario.curves.create!(name: "CAC40", description: "Le CAC 40 (cotation assistée en continu) est le principal indice boursier de la place de Paris.", nature: :reference, unit_name: "points", initial_amount: amount)
variation = 0
cursor = 1
while cursor < slength
  curve.steps.create!(turn: cursor, amount: amount.round(2))
  variation += 12 * (rand - 0.5)
  amount += variation
  cursor += rand(slength * 0.15).to_i + 1
end


game = Game.create!(scenario: scenario, name: "Sainte-Livrade 10月9日", description: "Phase de test grandeur nature")

85.times do |index|
  first_name, last_name = FFaker::NameFR.first_name, FFaker::NameFR.last_name.mb_chars.upcase
  email = "#{first_name}.#{last_name}@#{FFaker::Internet.domain_name}"
  User.create!(first_name: first_name, last_name: last_name, email: email, password: '12346578', password_confirmation: '12346578')
end


historic = Historic.create!(name: "4 ans en 47", currency: scenario.currency)

15.times do |index|
  game.farms.create!(name: "Ferme n°#{index + 1}", historic: historic)
end

farms = game.farms.to_a
User.find_each do |user|
  if farm = farms.sample
    game.participations.create!(participant: farm, user: user)
    farms.delete(farm) if farm.participations.count >= 4
  end
end


["Crédit Agricole", "Groupama", "Unicoque", "Terre du Sud", "Razol", "CER", "@com", "MSA"].each do |name|
  game.actors.create!(name: name)
end
