require 'active_record'
require 'sqlite3'
require 'logger'

ActiveRecord::Base.logger = Logger.new("#{ENV.fetch('PWD')}/debug.log")
configuration = YAML::load(IO.read("#{ENV.fetch('PWD')}/config/database.yml"))
development_configuration = configuration['development']
if development_configuration['adapter'] == 'sqlite3'
	development_configuration['database'] = "#{ENV.fetch('PWD')}/#{development_configuration['database']}"
end
ActiveRecord::Base.establish_connection(configuration['development'])

# recursively requires all files in ./lib and down that end in .rb
Dir.glob("#{ENV.fetch('PWD')}/models/*.rb").each do |file|
	require file
end
Dir.glob("#{ENV.fetch('PWD')}/lib/*.rb").each do |file|
	require file
end
