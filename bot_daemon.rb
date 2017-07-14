require 'daemons'

options = {
	backtrace: true,
	log_output: true,
	monitor: true
}
Daemons.run('bot_main.rb', options)
