require 'telegram/bot'
require 'optparse'

options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: botling.rb [options]"
	opts.on('-p', '--script-path PATH', 'The path where the script is located') { |v| ENV['PWD'] = v }
end.parse!

require_relative 'environment'

online_at = Time.now

logger = Logger.new("#{ENV.fetch('PWD')}/botling.log")

botling = Botling.new
command_handler = CommandHandler.new(botling.bot_nickname)
botling.register_commands(command_handler)

Telegram::Bot::Client.run(ENV['BOT_TOKEN'], logger: logger) do |bot|
	botling.bot = bot
	command_handler.bot = bot
	bot.listen do |message|
		begin
			if botling.pending.has_key?(message.from.id)
				to_call = botling.pending[message.from.id]
				botling.pending.delete(message.from.id)
				to_call.call(message, nil)
			else
				command, parameters = message.text.split(" ", 2)
				case command
				when '/online'
					bot.api.send_message(chat_id: message.chat.id, reply_to_message_id: message.message_id, text: "Tô aqui online desde #{online_at.strftime("%H:%M de %d/%m/%Y")}.")
				end
				command_handler.handle(command, parameters, message)
			end
		rescue => e
			logger.error "Something went wrong! #{e}"
		end
	end
end
