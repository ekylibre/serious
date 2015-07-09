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
  if User.find_by(email: user["email"])
    print "-"
  else
    User.create!(user.merge(password: '12345678', password_confirmation: '12345678'))
    print "·"
  end
end
if User.find_by(email: "admin@ekylibre.org")
  print "="
else
  User.create!(email: "admin@ekylibre.org", password: '12345678', password_confirmation: '12345678', first_name: "Admin", last_name: "STRATOR", role: :administrator)
  print "•"
end
puts "!"


print "Historics: "
Dir.glob(root.join("db", "historics", "*.yml")).each do |file|
  Historic.import(file)
  print "·"
end
puts "!"

puts "Scenarios:"
Dir.glob(root.join("db", "scenarios", "*.yml")).each do |file|
  print "  " + File.basename(file) + ": "
  Scenario.import(file)
  puts "!"
end

puts "Games: "
Dir.glob(root.join("db", "games", "*.yml")).each do |file|
  print "  " + File.basename(file) + ": "
  Game.import(file)
  puts "!"
end
