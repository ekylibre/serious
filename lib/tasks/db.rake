namespace :db do
  desc 'Also create shared extensions schemas'
  task extensions: :environment do
    ActiveRecord::Base.connection.execute 'CREATE SCHEMA IF NOT EXISTS postgis;'
    ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS postgis SCHEMA postgis;'
  end

  task rebuild: ['db:drop', 'db:create', 'db:migrate', 'db:seed']
end

Rake::Task['db:create'].enhance do
  Rake::Task['db:extensions'].invoke
end

Rake::Task['db:test:purge'].enhance do
  Rake::Task['db:extensions'].invoke
end
