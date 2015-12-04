require 'active_record'
require 'sqlite3'
require 'logger'

ActiveRecord::Base.logger = Logger.new('debug.log')
configuration = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

# recursively requires all files in ./lib and down that end in .rb
Dir.glob("./models/*.rb").each do |file|
	require file
end
