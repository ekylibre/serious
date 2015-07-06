# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

root = Rails.root

print "Users: "
YAML.load_file(root.join("db", "users.yml")).each do |user|
  unless User.find_by(email: user["email"])
    User.create!(user.merge(password: '12345678', password_confirmation: '12345678'))
    print "."
  end
end
puts ""

print "Scenario: "
Dir.glob(root.join("db", "scenarios", "*.yml")).each do |file|
  Scenario.import(file)
  print "."
end
puts ""

print "Historic: "
Dir.glob(root.join("db", "historics", "*.yml")).each do |file|
  Historic.import(file)
  print "."
end
puts ""

print "Games: "
Dir.glob(root.join("db", "games", "*.yml")).each do |file|
  Game.import(file)
  print "."
end
puts ""
