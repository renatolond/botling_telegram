require_relative 'environment'

namespace :db do
	desc "Run migrations"
	task :migrate do
		ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
	end

	desc "Seed the database"
	task :seed do
		ruby "db/seeds.rb"
	end
end
